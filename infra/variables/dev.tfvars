# GCP Project Configuration
project     = "dataascode"
region      = "europe-west1"


# Cloud Run Configuration
name_ressource_cloud_run                        = "event-driven-api-dev"
container_port                                   = 8000
google_service_account_cloudrun_runtime_email    = "cloudrun-runtime-dev@dataascode.iam.gserviceaccount.com"
endpoint_target_cloudrun_uri                     = "https://event-driven-api-dev-xxxxxxxxxx-ew.a.run.app"

# Pub/Sub Configuration
topic_name         = "event-ingestion-dev"
source_topic_name  = "event-ingestion-dev"

# Eventarc Configuration
eventarc_name = "event-trigger-dev"
label         = "event-driven-dev"
