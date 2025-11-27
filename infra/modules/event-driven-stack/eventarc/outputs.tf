output "cloudrun_trigger_name" {
  description = "Names of the created Cloud Run Eventarc triggers"
  value       = google_eventarc_trigger.cloudrun_triggers.name
}

output "cloudrun_trigger_id" {
  description = "IDs of the created Cloud Run Eventarc triggers"
  value       = google_eventarc_trigger.cloudrun_triggers.id
}
