provider "google" {
  project = local.project_id
  region  = local.region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.31.0"
    }
  }

  required_version = "~> 1.0"
}

# Path: infra/3-network.tf