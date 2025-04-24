#!/bin/bash

echo "Starting automated Terraform deployment..."

PROJECT_ID=akvelon-gke-aieco
if [ -z "$PROJECT_ID" ]; then
  echo "Error: No project ID set. Please set a project with 'gcloud config set project PROJECT_ID'."
  exit 1
fi

git clone https://github.com/alex-akv/cloud-shell-automate.git /home/user/deployment
cd /home/user/deployment

terraform init -backend-config="bucket=tf-state-${PROJECT_ID}" -backend-config="prefix=terraform/state"

terraform apply -auto-approve

echo "Deployment complete! To destroy the infrastructure, run 'terraform destroy' in /home/user/deployment."