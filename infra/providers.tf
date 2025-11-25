terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.31.1"
    }
  }

  backend "gcs" {

  }
}


provider "google" {
  project = var.project
  region  = var.region
}
