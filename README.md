# GKE Deployment with Terraform

This repository provides a script to deploy or destroy a GKE cluster and an example Nginx application using Terraform. The Terraform state is stored in a GCS bucket.

## Prerequisites
- Google Cloud project with billing enabled.
- Permissions to create GKE clusters and GCS buckets.

## Usage
1. Click on the "Run in Cloud Shell" button below.
2. Run the script with either "deploy" or "destroy" argument:
   - To deploy: `./automate.sh deploy`
   - To destroy: `./automate.sh destroy`
3. When prompted, enter your Google Cloud project ID.

### Run in Cloud Shell
Click the button below to open this repository in Cloud Shell:

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/alex-akv/cloud-shell-automate.git&cloudshell_tutorial=README.md)

## Cleanup
To destroy the infrastructure, run:
```bash
./automate.sh destroy
```

## Notes
- The script waits for the GKE cluster to be ready before deploying Nginx.