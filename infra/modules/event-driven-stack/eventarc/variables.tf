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

variable "endpoint_target_cloudrun_uri" {
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
