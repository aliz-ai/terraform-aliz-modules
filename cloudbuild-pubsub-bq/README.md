# Log Cloud Build events to BigQuery

This module adds two elements in the given project:
 * Creates the 'cloud-builds' Pub/Sub topic as described in https://cloud.google.com/build/docs/subscribe-build-notifications
 * Adds a target BigQuery dataset and table, and a BigQuery subscription to the pubsub topic, as described in https://cloud.google.com/pubsub/docs/bigquery

### Example usage
```
module "cloudbuild_logging" {
  source = "git::https://github.com/aliz-ai/terraform-aliz-modules//cloudbuild-pubsub-bq"
  project_id = module.project_cicd.project_id
  project_number = module.project_cicd.project.number
  bigquery_location = "EU"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.76.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_bigquery_dataset.dataset](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_bigquery_dataset_iam_member.editor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_iam_member) | resource |
| [google_bigquery_dataset_iam_member.viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_iam_member) | resource |
| [google_bigquery_table.cloudbuild_events](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table) | resource |
| [google_project_service.services](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_pubsub_subscription.bq_subscription](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | resource |
| [google_pubsub_topic.cb_topic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bigquery_location"></a> [bigquery\_location](#input\_bigquery\_location) | The location for the BigQuery dataset | `string` | `"EU"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The id of the project to use. | `string` | n/a | yes |
| <a name="input_project_number"></a> [project\_number](#input\_project\_number) | The numberic code of the project to use. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
