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

variable "name_image_docker" {
  type        = string
  description = "Name of the Docker image generated and stored in Artifact Registry."
}

variable "google_service_account_cloudrun_runtime_email" {
  type        = string
  description = "Email of the Google service account used for Cloud Run service execution."
}

variable "container_port" {
  type        = number
  description = "Port on which the Cloud Run container listens for HTTP requests."
}

variable "github_sha" {
  type        = string
  description = "GitHub commit identifier (SHA) used to tag the Docker image."
}

variable "artifactory_repository_id" {
  type        = string
  description = "Artifact Registry repository identifier where the Docker image is stored."
}

variable "eventarc_name" {
  type        = string
  description = "The service account to use to execute the Eventarc triggers"
}


variable "label" {
  type        = string
  description = "The service account to use to execute the Eventarc triggers"
}

variable "source_topic_name" {
  type        = string
  description = "The service account to use to execute the Eventarc triggers"
}

variable "name_ressource_cloud_run" {
  type        = string
  description = "Name of the deployed Cloud Run resource."
}

variable "topic_name" {
  type        = string
  description = "Pub/Sub topic name."
}

variable "cloud_run_service_path" {
  type        = string
  description = "GCP project name."
}
