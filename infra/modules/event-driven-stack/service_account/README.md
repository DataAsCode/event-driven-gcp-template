# service_account

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
| [google_project_iam_member.cloudrun_bigquery_jobuser](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.cloudrun_secret_accessor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.eventarc_event_receiver](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.eventarc_pubsub_subscriber](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.eventarc_run_invoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.cloudrun_runtime](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.eventarc_triggers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Target environment (e.g., dev, staging, prod). | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | GCP project name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_google_service_account_cloudrun_runtime_email"></a> [google\_service\_account\_cloudrun\_runtime\_email](#output\_google\_service\_account\_cloudrun\_runtime\_email) | Email of the Cloud Run runtime service account |
| <a name="output_google_service_account_cloudrun_runtime_name"></a> [google\_service\_account\_cloudrun\_runtime\_name](#output\_google\_service\_account\_cloudrun\_runtime\_name) | Name of the Cloud Run runtime service account |
| <a name="output_google_service_account_eventarc_triggers_email"></a> [google\_service\_account\_eventarc\_triggers\_email](#output\_google\_service\_account\_eventarc\_triggers\_email) | Email of the Eventarc triggers service account |
| <a name="output_google_service_account_eventarc_triggers_name"></a> [google\_service\_account\_eventarc\_triggers\_name](#output\_google\_service\_account\_eventarc\_triggers\_name) | Name of the Eventarc triggers service account |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
