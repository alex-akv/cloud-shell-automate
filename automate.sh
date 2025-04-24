#!/bin/bash

echo "Starting automated GKE deployment..."

PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
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
  --quiet | tee /dev/tty

echo "Fetching cluster credentials..."
gcloud container clusters get-credentials my-gke-cluster \
  --zone us-central1-a \
  --project "$PROJECT_ID" | tee /dev/tty

echo "Waiting for cluster to be ready..."
sleep 60

echo "Deploying application..."
kubectl apply -f deployment.yaml | tee /dev/tty

echo "Setup complete! Check your deployment with 'kubectl get pods'."