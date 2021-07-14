# CloudSQL Scheduled Export

## Overview

This terraform module create several resources which will be used to automate the export of data from a CloudSQL instance.

## Required Resources

The following resources should be created and configured properly prior to running this module.

1. CloudSQL Instance
2. Cloud Storage Bucket
    * Cloud Storage permission allow Cloud SQL in item 1 to do the following actions: `storage.objects.create` and `storage.objects.create`.

### Installation Dependencies

### Enable APIs

* Cloud SQL Admin API: `sqladmin.googleapis.com`
* Cloud Scheduler : `cloudscheduler.googleapis.com`
* Cloud Function : `cloudfunctions.googleapis.com`
* Cloud PubSub : `pubsub.googleapis.com`
* Cloud Storage : `storage.googleapis.com`
* Cloud Build API : `cloudbuild.googleapis.com`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_scheduler_job.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) | resource |
| [google_cloudfunctions_function.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function) | resource |
| [google_project_iam_binding.gcf_role_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_custom_role.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_pubsub_topic.cloudsql_export](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_service_account.function_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket.function_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.function_archive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [archive_file.function_source](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_bucket"></a> [backup\_bucket](#input\_backup\_bucket) | Cloud Storage bucket name to store SQL export | `string` | n/a | yes |
| <a name="input_cloud_scheduler_description"></a> [cloud\_scheduler\_description](#input\_cloud\_scheduler\_description) | Description of the cloud scheduler used to schedule Cloud SQL export. | `string` | n/a | yes |
| <a name="input_cloud_scheduler_name"></a> [cloud\_scheduler\_name](#input\_cloud\_scheduler\_name) | Name of the cloud scheduler used to Schdule Cloud SQL Export | `string` | n/a | yes |
| <a name="input_cloud_scheduler_region"></a> [cloud\_scheduler\_region](#input\_cloud\_scheduler\_region) | Region to deploy Cloud Scheduler. This should be the same region with your app engine region | `string` | n/a | yes |
| <a name="input_cloud_scheduler_schedule"></a> [cloud\_scheduler\_schedule](#input\_cloud\_scheduler\_schedule) | Schedule of the Cloud SQL export (in crontab format) | `string` | n/a | yes |
| <a name="input_cloud_scheduler_time_zone"></a> [cloud\_scheduler\_time\_zone](#input\_cloud\_scheduler\_time\_zone) | Time zone of the cloud scheduler | `string` | n/a | yes |
| <a name="input_cloudsql_database_names"></a> [cloudsql\_database\_names](#input\_cloudsql\_database\_names) | List of databases to be backup | `string` | n/a | yes |
| <a name="input_cloudsql_instance_name"></a> [cloudsql\_instance\_name](#input\_cloudsql\_instance\_name) | Cloud SQL instance name to be backup | `string` | n/a | yes |
| <a name="input_function_archive_name"></a> [function\_archive\_name](#input\_function\_archive\_name) | Cloud function source code archive name. This file is the one that will be uploaded to Cloud Storage Bucket for Cloud Function Deployment | `string` | `"cloudsql_exporter.zip"` | no |
| <a name="input_function_bucket_name"></a> [function\_bucket\_name](#input\_function\_bucket\_name) | Cloud Storage Bucket Name to store Cloud Functions source code | `string` | n/a | yes |
| <a name="input_function_description"></a> [function\_description](#input\_function\_description) | Cloud function description | `string` | `"Cloud SQL schduled export to Cloud Storage"` | no |
| <a name="input_function_memory_mb"></a> [function\_memory\_mb](#input\_function\_memory\_mb) | Memory (in MB), available to the function. Default value is 128. | `string` | `"128"` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Cloud function name for Cloud SQL data export | `string` | `"cloudsql-data-export"` | no |
| <a name="input_function_role_description"></a> [function\_role\_description](#input\_function\_role\_description) | A human-readable description for the role. | `string` | n/a | yes |
| <a name="input_function_role_id"></a> [function\_role\_id](#input\_function\_role\_id) | The camel case role id to use for this role. Cannot contain - characters. | `string` | n/a | yes |
| <a name="input_function_role_title"></a> [function\_role\_title](#input\_function\_role\_title) | A human-readable title for the role. | `string` | n/a | yes |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | The runtime in which the function is going to run. | `string` | `"python38"` | no |
| <a name="input_function_service_account_name"></a> [function\_service\_account\_name](#input\_function\_service\_account\_name) | Custom IAM service account name that will be used by Cloud Function. | `string` | n/a | yes |
| <a name="input_label_environment"></a> [label\_environment](#input\_label\_environment) | label environment | `string` | `"production"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID where this stack should be deployed | `string` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | PubSub Topic Name for Cloud Scheduler to post scheduler data which will trigger Cloud Function | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Architecture Design


