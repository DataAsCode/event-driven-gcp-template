output "cloud_run_service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_v2_service.cloudrun_dataascode_backend.name
}

output "cloud_run_service_id" {
  description = "ID of the Cloud Run service"
  value       = google_cloud_run_v2_service.cloudrun_dataascode_backend.id
}

output "cloud_run_service_url" {
  description = "URL of the Cloud Run service"
  value       = google_cloud_run_v2_service.cloudrun_dataascode_backend.uri
}

output "cloud_run_service_location" {
  description = "Location of the Cloud Run service"
  value       = google_cloud_run_v2_service.cloudrun_dataascode_backend.location
}

output "cloudrun_service" {
  description = "Full Cloud Run service resource for dependency management"
  value       = google_cloud_run_v2_service.cloudrun_dataascode_backend
}