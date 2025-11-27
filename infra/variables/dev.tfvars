# GCP Project Configuration
project = "dataascode"
region  = "europe-west1"

# Cloud Run Configuration
name_ressource_cloud_run = "event-driven-api-dev"
container_port           = 8000

# Pub/Sub Configuration
topic_name = "event-ingestion-dev"

# Eventarc Configuration
eventarc_name          = "event-trigger-dev"
label                  = "event-driven-dev"
cloud_run_service_path = "/api/v1/ingest_event"
