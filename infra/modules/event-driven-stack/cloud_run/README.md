# cloud_run

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_v2_service.cloudrun_dataascode_backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifactory_repository_id"></a> [artifactory\_repository\_id](#input\_artifactory\_repository\_id) | Artifact Registry repository identifier where the Docker image is stored. | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Container listening port for HTTP connections. | `number` | `8000` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Target environment (e.g., dev, staging, prod). | `string` | n/a | yes |
| <a name="input_github_sha"></a> [github\_sha](#input\_github\_sha) | GitHub commit identifier (SHA) used to tag the Docker image. | `string` | n/a | yes |
| <a name="input_google_service_account_cloudrun_runtime_email"></a> [google\_service\_account\_cloudrun\_runtime\_email](#input\_google\_service\_account\_cloudrun\_runtime\_email) | Email of the Google service account used for Cloud Run service execution. | `string` | n/a | yes |
| <a name="input_name_image_docker"></a> [name\_image\_docker](#input\_name\_image\_docker) | Name of the Docker image generated and stored in Artifact Registry. | `string` | n/a | yes |
| <a name="input_name_ressource_cloud_run"></a> [name\_ressource\_cloud\_run](#input\_name\_ressource\_cloud\_run) | Name of the deployed Cloud Run resource. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | GCP project name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region where resources will be deployed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_run_service_id"></a> [cloud\_run\_service\_id](#output\_cloud\_run\_service\_id) | ID of the Cloud Run service |
| <a name="output_cloud_run_service_location"></a> [cloud\_run\_service\_location](#output\_cloud\_run\_service\_location) | Location of the Cloud Run service |
| <a name="output_cloud_run_service_name"></a> [cloud\_run\_service\_name](#output\_cloud\_run\_service\_name) | Name of the Cloud Run service |
| <a name="output_cloud_run_service_url"></a> [cloud\_run\_service\_url](#output\_cloud\_run\_service\_url) | URL of the Cloud Run service |
| <a name="output_cloudrun_service"></a> [cloudrun\_service](#output\_cloudrun\_service) | Full Cloud Run service resource for dependency management |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
