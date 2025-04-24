provider "google" {
  project = var.project_id
  region  = "us-central1"
}

variable "project_id" {
  description = "Google Cloud project ID"
  default     = "akvelon-gke-aieco" 
}

resource "google_storage_bucket" "tf_state" {
  name          = "tf-state-demo-${var.project_id}"
  location      = "US"
  force_destroy = true
}

terraform {
  backend "gcs" {
    bucket = "tf-state-demo-akvelon-gke-aieco" 
    prefix = "terraform/state"
  }
}

resource "google_container_cluster" "primary" {
  name               = "my-gke-cluster"
  location           = "us-central1-a"
  initial_node_count = 1
  node_config {
    machine_type = "e2-micro"
  }
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

data "google_client_config" "default" {}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deployment"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

output "destroy_instructions" {
  value = "To destroy the infrastructure, run 'terraform destroy' in this directory."
}