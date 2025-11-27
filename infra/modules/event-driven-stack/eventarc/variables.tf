variable "project" {
  type        = string
  description = "The GCP project ID where resources will be created"
}

variable "region" {
  type        = string
  default     = "europe-west9"
  description = "Region where GCP services will be deployed"
}

variable "service_account_email" {
  type        = string
  description = "The service account to use to execute the Eventarc triggers"
}

variable "event_type" {
  type        = string
  default     = "google.cloud.pubsub.topic.v1.messagePublished"
  description = "The event type to trigger on (default: Pub/Sub message published)"
}

variable "eventarc_name" {
  type        = string
  description = "The service account to use to execute the Eventarc triggers"
}

variable "cloud_run_service_name" {
  type        = string
  description = "Name of the Cloud Run service to trigger"
}

variable "cloud_run_service_path" {
  type        = string
  description = "Path to the endpoint on the Cloud Run service"
}

variable "label" {
  type        = string
  description = "Label for the Eventarc trigger"
}

variable "source_topic_name" {
  type        = string
  description = "The service account to use to execute the Eventarc triggers"
}
