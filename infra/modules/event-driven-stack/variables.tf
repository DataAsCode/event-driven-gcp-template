variable "project" {
  type        = string
  description = "GCP project name."
}

variable "region" {
  type        = string
  description = "GCP region where resources will be deployed."
}

variable "environment" {
  type        = string
  description = "Target environment (e.g., dev, staging, prod)."
}

variable "github_sha" {
  type        = string
  description = "GitHub commit identifier (SHA) used to tag the Docker image."
}

variable "artifactory_repository_id" {
  type        = string
  description = "Artifact Registry repository name where Docker images are stored."
}

variable "name_ressource_cloud_run" {
  type        = string
  description = "Name of the deployed Cloud Run resource."
}

variable "name_image_docker" {
  type        = string
  description = "Name of the Docker image generated and stored in Artifact Registry."
}

variable "container_port" {
  default     = 8000
  type        = number
  description = "Container listening port for HTTP connections."
}

variable "topic_name" {
  type        = string
  description = "Pub/Sub topic name."
}

variable "label" {
  type        = string
  description = "GCP project name."
}

variable "eventarc_name" {
  type        = string
  description = "GCP project name."
}

variable "suffixe_endpoint_target_cloudrun_uri" {
  type        = string
  description = "GCP project name."
}

