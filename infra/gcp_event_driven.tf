module "artifactory" {
  source                    = "./modules/artifactory"
  region                    = var.region
  artifactory_repository_id = var.artifactory_repository_id
}


module "gcp_event_driven" {
  source                               = "./modules/event-driven-stack"
  project                              = var.project
  region                               = var.region
  environment                          = var.environment
  github_sha                           = var.github_sha
  artifactory_repository_id            = module.artifactory.artifactory_repository_id
  name_ressource_cloud_run             = var.name_ressource_cloud_run
  name_image_docker                    = var.name_image_docker
  container_port                       = var.container_port
  topic_name                           = var.topic_name
  label                                = var.label
  suffixe_endpoint_target_cloudrun_uri = var.suffixe_endpoint_target_cloudrun_uri
  eventarc_name                        = var.eventarc_name
}
