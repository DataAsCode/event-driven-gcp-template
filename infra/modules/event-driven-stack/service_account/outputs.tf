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
