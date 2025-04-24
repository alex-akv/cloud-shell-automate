#!/bin/bash
echo "Starting automated task at $(date)"
echo "Script started at $(date)" > /tmp/run-once.log
PROJECT_ID="akvelon-gke-aieco"
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
echo "Waiting for cluster to be ready..."
sleep 60
echo "Deploying application..."
kubectl apply -f /home/user/cloudshell_open/cloud-shell-automate/deployment.yaml
echo "Task complete! Check your deployment with 'kubectl get pods'."