variable "name_ressource_cloud_run" {
  type        = string
  description = "Name of the deployed Cloud Run resource."
}

variable "region" {
  type        = string
  description = "GCP region where resources will be deployed."
}

variable "project" {
  type        = string
  description = "GCP project name."
}

variable "environment" {
  type        = string
  description = "Target environment (e.g., dev, staging, prod)."
}

variable "name_image_docker" {
  type        = string
  description = "Name of the Docker image generated and stored in Artifact Registry."
}

variable "google_service_account_cloudrun_runtime_email" {
  type        = string
  description = "Email of the Google service account used for Cloud Run service execution."
}

variable "container_port" {
  default     = 8000
  type        = number
  description = "Container listening port for HTTP connections."
}

variable "github_sha" {
  type        = string
  description = "GitHub commit identifier (SHA) used to tag the Docker image."
}

variable "artifactory_repository_id" {
  type        = string
  description = "Artifact Registry repository identifier where the Docker image is stored."
}
