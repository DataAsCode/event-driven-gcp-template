# event-driven-stack

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_run"></a> [cloud\_run](#module\_cloud\_run) | ./cloud_run | n/a |
| <a name="module_eventarc"></a> [eventarc](#module\_eventarc) | ./eventarc | n/a |
| <a name="module_pubsub"></a> [pubsub](#module\_pubsub) | ./pubsub | n/a |
| <a name="module_service_account"></a> [service\_account](#module\_service\_account) | ./service_account | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifactory_repository_id"></a> [artifactory\_repository\_id](#input\_artifactory\_repository\_id) | Artifact Registry repository name where Docker images are stored. | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Container listening port for HTTP connections. | `number` | `8000` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Target environment (e.g., dev, staging, prod). | `string` | n/a | yes |
| <a name="input_eventarc_name"></a> [eventarc\_name](#input\_eventarc\_name) | GCP project name. | `string` | n/a | yes |
| <a name="input_github_sha"></a> [github\_sha](#input\_github\_sha) | GitHub commit identifier (SHA) used to tag the Docker image. | `string` | n/a | yes |
| <a name="input_label"></a> [label](#input\_label) | GCP project name. | `string` | n/a | yes |
| <a name="input_name_image_docker"></a> [name\_image\_docker](#input\_name\_image\_docker) | Name of the Docker image generated and stored in Artifact Registry. | `string` | n/a | yes |
| <a name="input_name_ressource_cloud_run"></a> [name\_ressource\_cloud\_run](#input\_name\_ressource\_cloud\_run) | Name of the deployed Cloud Run resource. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | GCP project name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region where resources will be deployed. | `string` | n/a | yes |
| <a name="input_suffixe_endpoint_target_cloudrun_uri"></a> [suffixe\_endpoint\_target\_cloudrun\_uri](#input\_suffixe\_endpoint\_target\_cloudrun\_uri) | GCP project name. | `string` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | Pub/Sub topic name. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
