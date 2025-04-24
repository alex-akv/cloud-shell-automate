#!/bin/bash
### BEGIN INIT INFO
# Provides:          run-once
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Run automation script once on startup
# Description:       Executes an automation task once at Cloud Shell startup
### END INIT INFO

FLAG_FILE="/var/run/run-once.done"

if [ -f "$FLAG_FILE" ]; then
    echo "Script already executed, skipping."
    exit 0
fi

case "$1" in
  start)
    echo "Starting automated task at $(date)"

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

    touch "$FLAG_FILE"
    ;;
  stop|restart|reload|force-reload)
    ;;
  *)
    echo "Usage: $0 {start}" >&2
    exit 3
    ;;
esac

exit 0