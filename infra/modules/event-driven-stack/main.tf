module "service_account" {
  source      = "./service_account"
  project     = var.project
  environment = var.environment
}

module "pubsub" {
  source     = "./pubsub"
  topic_name = var.topic_name
}

module "cloud_run" {
  source                                        = "./cloud_run"
  project                                       = var.project
  region                                        = var.region
  environment                                   = var.environment
  name_ressource_cloud_run                      = var.name_ressource_cloud_run
  name_image_docker                             = var.name_image_docker
  google_service_account_cloudrun_runtime_email = module.service_account.google_service_account_cloudrun_runtime_email
  container_port                                = var.container_port
  github_sha                                    = var.github_sha
  artifactory_repository_id                     = var.artifactory_repository_id

  depends_on = [module.service_account]
}

module "eventarc" {
  source                 = "./eventarc"
  project                = var.project
  region                 = var.region
  service_account_email  = module.service_account.google_service_account_eventarc_triggers_email
  label                  = var.label
  source_topic_name      = module.pubsub.pubsub_topic_name
  eventarc_name          = var.eventarc_name
  cloud_run_service_name = module.cloud_run.cloud_run_service_name
  cloud_run_service_path = var.cloud_run_service_path

  depends_on = [module.service_account, module.pubsub, module.cloud_run]
}
