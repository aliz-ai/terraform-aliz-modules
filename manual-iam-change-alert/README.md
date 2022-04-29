# Bitbucket GCP Cloud Build Status response

## Overview

The purpose of this module is to notify the provided Google Chat Space when a role is changed by unauthorized user on the GCP Organization or on any child Folders. (Projects are ignored.)

The solution relies on the audit-logs written by the resource where the change happened. A log-sink is created in the organization with the required filter, routing the logs to a Pub/Sub topic. In case of such an event, a JS script running in Cloud Function will send a formatted message with the informations from the log to the provided Google Chat API webhook.

To use this module, a Google Chat Space webhook is require to be set up. This can be done by following the following documentation: https://developers.google.com/chat/how-tos/webhooks#define_an_incoming_webhook  
The webhook has to be stored in the Secret Manager.
  
Created resources:
* Log sink
* Pub/Sub topic
* Cloud Function
* GCS Bucket

## Required Resources

The following resources should be created and configured properly prior to running this module.

1. Google Chat Space webhook
2. Secret Manager

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
| [google_cloudfunctions_function.iam_change_log_function](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function) | resource |
| [google_logging_organization_sink.iam_change_log_sink](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_organization_sink) | resource |
| [google_pubsub_topic.iam_change_log_topic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_pubsub_topic_iam_member.iam_change_log_topic_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_member) | resource |
| [google_secret_manager_secret_iam_member.secret_accessor_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_storage_bucket.function_source_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.cloud_function_archive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [archive_file.function_source](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_infra_service_account"></a> [infra\_service\_account](#input\_infra\_service\_account) | The service account used by the infra project. | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | The organization ID | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project to use. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to be used for the function. | `string` | n/a | yes |
| <a name="input_webhook_secret"></a> [webhook\_secret](#input\_webhook\_secret) | The ID of the secret (not the full resource name) where the webhook is stored. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Architecture Design


