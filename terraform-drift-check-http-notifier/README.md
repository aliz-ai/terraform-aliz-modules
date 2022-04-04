# Bitbucket GCP Cloud Build Status response

## Overview

The purpose of this module is to let a Bitbucket-based Cloud Build pipeline report build status to Bitbucket. This feature is automatically provided for Github by the Cloud Build Github app, but there's no such feature (at least yet) for Bitbucket.

The solution relies on the logs written by Cloud Build to Cloud Logging to detect certain build events. In case of such an event, a python script running in Cloud Function will check the build on the Cloud Build API and then do the reporting to Bitbucket over its API.

To authenticate the requests to Bitbucket, you need to follow the steps "Client Credentials Grant (4.4)" part from https://developer.atlassian.com/cloud/bitbucket/oauth-2/ to create an OAuth consumer, for example by navigating to https://bitbucket.org/<<YOUR ORG NAME>>/workspace/settings/oauth-consumers/new and then store the available "Key" and "Secret" values in Secret Manager, providing the secret ids to this module. The module will try to grant access to the secrets for the Cloud Functions service account. 
  
Created resources:
* Log sink
* Pub/Sub topic
* Cloud Function
* GCS Bucket

## Required Resources

The following resources should be created and configured properly prior to running this module.

1. Cloud Build
2. Secret Manager
3. Bitbucket OAuth

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bitbucket_key_resource_id"></a> [bitbucket\_key\_resource\_id](#input\_bitbucket\_key\_resource\_id) | The fully qualified Secret Manager name of the BitBucket OAuth key with version included. | `string` | n/a | yes |
| <a name="input_bitbucket_owner"></a> [bitbucket\_owner](#input\_bitbucket\_owner) | Bitbucket repo owner for the API. | `string` | n/a | yes |
| <a name="input_bitbucket_repo"></a> [bitbucket\_repo](#input\_bitbucket\_repo) | Name of the bitbucket repo. | `string` | n/a | yes |
| <a name="input_bitbucket_secret_resource_id"></a> [bitbucket\_secret\_resource\_id](#input\_bitbucket\_secret\_resource\_id) | The fully qualified Secret Manager name of the BitBucket OAuth secret with version included. | `string` | n/a | yes |
| <a name="input_function_archive_name"></a> [function\_archive\_name](#input\_function\_archive\_name) | Cloud function source code archive name. This file is the one that will be uploaded to Cloud Storage Bucket for Cloud Function Deployment | `string` | `"build-stat-resp.zip"` | no |
| <a name="input_function_description"></a> [function\_description](#input\_function\_description) | Description for the function. | `string` | `"Cloud build status response to Bitbucket"` | no |
| <a name="input_function_memory_mb"></a> [function\_memory\_mb](#input\_function\_memory\_mb) | Memory (in MB), available to the function. Default value is 128. | `string` | `"128"` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Cloud Function. | `string` | `"bitbucket-build-status-update"` | no |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | Runtime in which the function is going to run. | `string` | `"python39"` | no |
| <a name="input_logsink_name"></a> [logsink\_name](#input\_logsink\_name) | Name of the Sink posting build logs to PubSub. | `string` | `"bitbucket_build_logs"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The id of the project where this stack will be deployed. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where to create the Storage Bucket and Cloud Function. | `string` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | PubSub Topic name for Log Sink to post logs which will trigger Cloud Function. | `string` | `"bitbucket_build_logs"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Architecture Design


