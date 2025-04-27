provider "google" {
  project = var.project_id
  region  = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1-a"

  initial_node_count = 1

  node_config {
    machine_type = "e2-micro"
  }
}

variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

terraform {
  backend "gcs" {
    prefix = "terraform/state"
  }
}