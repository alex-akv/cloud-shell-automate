#!/bin/bash

if [ "$1" != "deploy" ] && [ "$1" != "destroy" ]; then
  echo "Usage: $0 {deploy|destroy}"
  exit 1
fi

ACTION=$1

read -p "Enter your Google Cloud project ID: " PROJECT_ID

gcloud config set project "$PROJECT_ID"

BUCKET_NAME="tf-state-demo-${PROJECT_ID}"

if [ "$ACTION" == "deploy" ]; then
  if ! gsutil ls -b "gs://$BUCKET_NAME" >/dev/null 2>&1; then
    echo "Creating GCS bucket for Terraform state..."
    gsutil mb -p "$PROJECT_ID" "gs://$BUCKET_NAME"
    gsutil versioning set on "gs://$BUCKET_NAME"
  fi

  echo "Initializing Terraform..."
  terraform init -backend-config="bucket=$BUCKET_NAME" -backend-config="prefix=terraform/state"

  echo "Applying Terraform configuration..."
  terraform apply -var "project_id=$PROJECT_ID" -auto-approve

  echo "Fetching cluster credentials..."
  gcloud container clusters get-credentials my-gke-cluster --zone us-central1-a --project "$PROJECT_ID"

  echo "Waiting for cluster to be ready..."
  until kubectl get nodes >/dev/null 2>&1; do
    echo "Cluster not ready yet, waiting 10 seconds..."
    sleep 10
  done
  echo "Cluster is ready!"

  if [ -f "deployment.yaml" ]; then
    echo "Deploying application..."
    kubectl apply -f deployment.yaml
  else
    echo "Error: deployment.yaml not found."
    exit 1
  fi

  echo "Deployment complete! Check your deployment with 'kubectl get pods'."

elif [ "$ACTION" == "destroy" ]; then
  echo "Initializing Terraform..."
  terraform init -backend-config="bucket=$BUCKET_NAME" -backend-config="prefix=terraform/state"

  echo "Destroying infrastructure..."
  terraform destroy -var "project_id=$PROJECT_ID" -auto-approve

  echo "Destruction complete."
fi