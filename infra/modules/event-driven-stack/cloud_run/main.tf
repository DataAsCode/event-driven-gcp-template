resource "google_cloud_run_v2_service" "cloudrun_dataascode_backend" {
  name                = var.name_ressource_cloud_run
  location            = var.region
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = var.google_service_account_cloudrun_runtime_email


    containers {
      image = "${var.region}-docker.pkg.dev/${var.project}/${var.artifactory_repository_id}/${var.name_image_docker}:${var.github_sha}"
      ports {
        container_port = var.container_port
      }

      volume_mounts {
        name       = "cloudrun-service-key-volume"
        mount_path = "/secrets"
      }
    }
  }
}
