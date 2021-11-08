# Bitbucket GCP Cloud Build Status response

## Overview

This terraform module create several resources which will be used to automate the Cloud Build status response to the Bitbucket API.

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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_random"></a> [random](#provider\_random)  | n/a |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|

| [google_logging_project_sink.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink) | resource |
| [google_cloudfunctions_function.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function) | resource |
| [google_project_iam_binding.log_sink](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_pubsub_topic.build_logs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_storage_bucket.function_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.function_archive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [random_id.storage_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [archive_file.function_source](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bitbucket_username"></a> [function\_bitbucket\_username](#input\_function\_bitbucket\_username) | Username of an authorized user to the corresponding Bitbucket project. | `string` | n/a | yes |
| <a name="input_bitbucket_password"></a> [function\_bitbucket\_password](#input\_function\_bitbucket\_password) | Password of an authorized user to the corresponding Bitbucket project. | `string` | n/a | yes |
| <a name="input_bitbucket_owner"></a> [function\_bitbucket\_owner](#input\_function\_bitbucket\_owner) | Owner of the corresponding Bitbucket project. | `string` | n/a | yes |
| <a name="input_bitbucket_repo"></a> [function\_bitbucket\_repo](#input\_function\_bitbucket\_repo) | Name of the reposisoty of the corresponding Bitbucket project. | `string` | n/a | yes |
| <a name="input_function_bucket_location"></a> [function\_bucket\_location](#input\_function\_bucket\_location) | Cloud Storage Bucket location to store Cloud Function source code. | `string` | n/a | yes |
| <a name="input_function_archive_name"></a> [function\_archive\_name](#input\_function\_archive\_name) | Cloud function source code archive name. This file is the one that will be uploaded to Cloud Storage Bucket for Cloud Function Deployment | `string` | `"build-stat-resp.zip"` | no |
| <a name="input_function_description"></a> [function\_description](#input\_function\_description) | Cloud function description | `string` | `"Cloud build status response to Bitbucket"` | no |
| <a name="input_function_memory_mb"></a> [function\_memory\_mb](#input\_function\_memory\_mb) | Memory (in MB), available to the function. Default value is 128. | `string` | `"128"` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Cloud function name for Bitbucket build status update | `string` | `"bitbucket-build-status-update"` | no |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | The runtime in which the function is going to run. | `string` | `"python39"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID where this stack should be deployed | `string` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | PubSub Topic Name for Cloud Scheduler to post scheduler data which will trigger Cloud Function | `string` | n/a | yes |
| <a name="input_logsink_name"></a> [logsink\_name](#input\_logsink\_name) | Cloud Logging logsink Name to publish logs to the trigger topic. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Architecture Design


