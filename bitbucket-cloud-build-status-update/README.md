# Bitbucket GCP Cloud Build Status response

## Overview

This terraform module create several resources which will be used to automate the Cloud Build status response to the Bitbucket API.  
  
Created resources:
* Log sink
* Pub/Sub topic
* Cloud Function
* GCS Bucket

## Required Resources

The following resources should be created and configured properly prior to running this module.

1. Cloud Build

### Installation Dependencies

### Enable APIs

* Cloud Logging : `logging.googleapis.com`
* Cloud Function : `cloudfunctions.googleapis.com`
* Cloud PubSub : `pubsub.googleapis.com`
* Cloud Storage : `storage.googleapis.com`
* Cloud Build API : `cloudbuild.googleapis.com`
* Secret Manager API : `secretmanager.googleapis.com`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloudfunctions_function.cloud_build_stat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function) | resource |
| [google_logging_project_sink.log_sink](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink) | resource |
| [google_project_iam_binding.log_writer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_pubsub_topic.build_logs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_secret_manager_secret_iam_binding.key_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_binding) | resource |
| [google_secret_manager_secret_iam_binding.secret_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_binding) | resource |
| [google_storage_bucket.function_source_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.cloud_function_archive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [archive_file.function_source](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [google_secret_manager_secret_version.bitbucket_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/secret_manager_secret_version) | data source |
| [google_secret_manager_secret_version.bitbucket_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/secret_manager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bitbucket_key_id"></a> [bitbucket\_key\_id](#input\_bitbucket\_key\_id) | Bitbucket OAuth key | `string` | n/a | yes |
| <a name="input_bitbucket_key_project_id"></a> [bitbucket\_key\_project\_id](#input\_bitbucket\_key\_project\_id) | ID of the project the OAuth key is stored in. | `string` | n/a | yes |
| <a name="input_bitbucket_key_version"></a> [bitbucket\_key\_version](#input\_bitbucket\_key\_version) | The version of the OAuth key. | `string` | `"latest"` | no |
| <a name="input_bitbucket_owner"></a> [bitbucket\_owner](#input\_bitbucket\_owner) | Bitbucket repo owner for the API. | `string` | n/a | yes |
| <a name="input_bitbucket_repo"></a> [bitbucket\_repo](#input\_bitbucket\_repo) | Name of the bitbucket repo. | `string` | n/a | yes |
| <a name="input_bitbucket_secret_id"></a> [bitbucket\_secret\_id](#input\_bitbucket\_secret\_id) | Bitbucket OAuth secret | `string` | n/a | yes |
| <a name="input_bitbucket_secret_project_id"></a> [bitbucket\_secret\_project\_id](#input\_bitbucket\_secret\_project\_id) | ID of the project the OAuth secret is stored in. | `string` | n/a | yes |
| <a name="input_bitbucket_secret_version"></a> [bitbucket\_secret\_version](#input\_bitbucket\_secret\_version) | The version of the OAuth secret. | `string` | `"latest"` | no |
| <a name="input_function_archive_name"></a> [function\_archive\_name](#input\_function\_archive\_name) | Cloud function source code archive name. This file is the one that will be uploaded to Cloud Storage Bucket for Cloud Function Deployment | `string` | `"build-stat-resp.zip"` | no |
| <a name="input_function_description"></a> [function\_description](#input\_function\_description) | Description for the function. | `string` | `"Cloud build status response to Bitbucket"` | no |
| <a name="input_function_memory_mb"></a> [function\_memory\_mb](#input\_function\_memory\_mb) | Memory (in MB), available to the function. Default value is 128. | `string` | `"128"` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Cloud Function. | `string` | `"bitbucket-build-status-update"` | no |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | Runtime in which the function is going to run. | `string` | `"python39"` | no |
| <a name="input_logsink_name"></a> [logsink\_name](#input\_logsink\_name) | Name of the Sink posting build logs to PubSub. | `string` | `"bitbucket_build_logs"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The id of the project where this stack will be deployed. | `string` | n/a | yes |
| <a name="input_project_location"></a> [project\_location](#input\_project\_location) | Cloud Storage Bucket location to store Cloud Function source code. | `string` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | PubSub Topic name for Log Sink to post logs which will trigger Cloud Function. | `string` | `"bitbucket_build_logs"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Architecture Design


