output "google_service_account_eventarc_triggers_email" {
  description = "Email of the Eventarc triggers service account"
  value       = google_service_account.eventarc_triggers.email
}

output "google_service_account_eventarc_triggers_name" {
  description = "Name of the Eventarc triggers service account"
  value       = google_service_account.eventarc_triggers.name
}

# Cloud Run runtime service account outputs
output "google_service_account_cloudrun_runtime_email" {
  description = "Email of the Cloud Run runtime service account"
  value       = google_service_account.cloudrun_runtime.email
}

output "google_service_account_cloudrun_runtime_name" {
  description = "Name of the Cloud Run runtime service account"
  value       = google_service_account.cloudrun_runtime.name
}

# Workflows execution service account outputs
output "google_service_account_workflows_execution_email" {
  description = "Email of the Workflows execution service account"
  value       = google_service_account.workflows_execution.email
}

output "google_service_account_workflows_execution_name" {
  description = "Name of the Workflows execution service account"
  value       = google_service_account.workflows_execution.name
}
