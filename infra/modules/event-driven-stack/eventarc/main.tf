resource "google_eventarc_trigger" "cloudrun_triggers" {
  name     = var.eventarc_name
  location = var.region
  project  = var.project
  service_account = var.service_account_email
  matching_criteria {
    attribute = "type"
    value     = var.event_type
  }
  destination {
    http_endpoint {
      uri = var.endpoint_target_cloudrun_uri
    }
  }
  labels = {
    environment = var.label
  }
  transport {
    pubsub {
      topic = var.source_topic_name
    }
  }
}