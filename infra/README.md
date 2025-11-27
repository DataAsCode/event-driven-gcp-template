# infra

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 7.12.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_artifactory"></a> [artifactory](#module\_artifactory) | ./modules/artifactory | n/a |
| <a name="module_gcp_event_driven"></a> [gcp\_event\_driven](#module\_gcp\_event\_driven) | ./modules/event-driven-stack | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifactory_repository_id"></a> [artifactory\_repository\_id](#input\_artifactory\_repository\_id) | Artifact Registry repository identifier where the Docker image is stored. | `string` | n/a | yes |
| <a name="input_cloud_run_service_path"></a> [cloud\_run\_service\_path](#input\_cloud\_run\_service\_path) | GCP project name. | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Port on which the Cloud Run container listens for HTTP requests. | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Target environment (e.g., dev, staging, prod). | `string` | n/a | yes |
| <a name="input_eventarc_name"></a> [eventarc\_name](#input\_eventarc\_name) | The service account to use to execute the Eventarc triggers | `string` | n/a | yes |
| <a name="input_github_sha"></a> [github\_sha](#input\_github\_sha) | GitHub commit identifier (SHA) used to tag the Docker image. | `string` | n/a | yes |
| <a name="input_google_service_account_cloudrun_runtime_email"></a> [google\_service\_account\_cloudrun\_runtime\_email](#input\_google\_service\_account\_cloudrun\_runtime\_email) | Email of the Google service account used for Cloud Run service execution. | `string` | n/a | yes |
| <a name="input_label"></a> [label](#input\_label) | The service account to use to execute the Eventarc triggers | `string` | n/a | yes |
| <a name="input_name_image_docker"></a> [name\_image\_docker](#input\_name\_image\_docker) | Name of the Docker image generated and stored in Artifact Registry. | `string` | n/a | yes |
| <a name="input_name_ressource_cloud_run"></a> [name\_ressource\_cloud\_run](#input\_name\_ressource\_cloud\_run) | Name of the deployed Cloud Run resource. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | GCP project name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region where resources will be deployed. | `string` | n/a | yes |
| <a name="input_source_topic_name"></a> [source\_topic\_name](#input\_source\_topic\_name) | The service account to use to execute the Eventarc triggers | `string` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | Pub/Sub topic name. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
