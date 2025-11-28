resource "google_service_account" "eventarc_triggers" {
  account_id   = "eventarc-triggers-${var.environment}"
  display_name = "Eventarc Triggers Service Account - ${var.environment}"
  description  = "Service account for Eventarc triggers with least privilege access"
}

resource "google_service_account" "cloudrun_runtime" {
  account_id   = "cloudrun-runtime-${var.environment}"
  display_name = "Cloud Run Runtime Service Account - ${var.environment}"
  description  = "Runtime service account for Cloud Run services"
}

# Eventarc specific IAM bindings with least privilege
resource "google_project_iam_member" "eventarc_event_receiver" {
  project = var.project
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.eventarc_triggers.email}"
}

resource "google_project_iam_member" "eventarc_run_invoker" {
  project = var.project
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.eventarc_triggers.email}"
}


resource "google_project_iam_member" "eventarc_pubsub_subscriber" {
  project = var.project
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.eventarc_triggers.email}"
}

# Cloud Run runtime IAM bindings
resource "google_project_iam_member" "cloudrun_secret_accessor" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloudrun_runtime.email}"
}

resource "google_project_iam_member" "cloudrun_bigquery_jobuser" {
  project = var.project
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.cloudrun_runtime.email}"
}

# GCS permissions pour lecture et écriture des objets
resource "google_project_iam_member" "cloudrun_storage_object_admin" {
  project = var.project
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.cloudrun_runtime.email}"
}
