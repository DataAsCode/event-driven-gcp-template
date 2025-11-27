# eventarc

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
| [google_eventarc_trigger.cloudrun_triggers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/eventarc_trigger) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_run_service_name"></a> [cloud\_run\_service\_name](#input\_cloud\_run\_service\_name) | Name of the Cloud Run service to trigger | `string` | n/a | yes |
| <a name="input_cloud_run_service_path"></a> [cloud\_run\_service\_path](#input\_cloud\_run\_service\_path) | Path to the endpoint on the Cloud Run service | `string` | n/a | yes |
| <a name="input_event_type"></a> [event\_type](#input\_event\_type) | The event type to trigger on (default: Pub/Sub message published) | `string` | `"google.cloud.pubsub.topic.v1.messagePublished"` | no |
| <a name="input_eventarc_name"></a> [eventarc\_name](#input\_eventarc\_name) | The service account to use to execute the Eventarc triggers | `string` | n/a | yes |
| <a name="input_label"></a> [label](#input\_label) | Label for the Eventarc trigger | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The GCP project ID where resources will be created | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where GCP services will be deployed | `string` | `"europe-west9"` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | The service account to use to execute the Eventarc triggers | `string` | n/a | yes |
| <a name="input_source_topic_name"></a> [source\_topic\_name](#input\_source\_topic\_name) | The service account to use to execute the Eventarc triggers | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudrun_trigger_id"></a> [cloudrun\_trigger\_id](#output\_cloudrun\_trigger\_id) | IDs of the created Cloud Run Eventarc triggers |
| <a name="output_cloudrun_trigger_name"></a> [cloudrun\_trigger\_name](#output\_cloudrun\_trigger\_name) | Names of the created Cloud Run Eventarc triggers |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
