#!/bin/bash

echo "Starting automated GKE deployment at $(date)"

echo "Waiting for project ID..."
for i in {1..60}; do
  PROJECT_ID=akvelon-gke-aieco
  if [ -n "$PROJECT_ID" ]; then
    echo "Project ID found: $PROJECT_ID"
    break
  fi
  echo "Project ID not set yet, waiting..."
  sleep 1
done

if [ -z "$PROJECT_ID" ]; then
  echo "Error: Project ID not set after 60 seconds. Please set a project with 'gcloud config set project PROJECT_ID' and try again."
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