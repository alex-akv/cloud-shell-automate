#!/bin/bash
echo "Starting automated GKE deployment..."

PROJECT_ID=$(gcloud config get-value project)
if [ -z "$PROJECT_ID" ]; then
  echo "Error: No project ID set. Please set a project with 'gcloud config set project PROJECT_ID'."
  exit 1
fi

echo "Creating GKE cluster..."
gcloud container clusters create my-gke-cluster \
  --zone us-central1-a \
  --machine-type e2-micro \
  --num-nodes 1 \
  --project "$PROJECT_ID" \
  --quiet

echo "Fetching cluster credentials..."
gcloud container clusters get-credentials my-gke-cluster \
  --zone us-central1-a \
  --project "$PROJECT_ID"

echo "Deploying..."
kubectl apply -f deployment.yaml

echo "Setup complete! Check your deployment with 'kubectl get pods'."