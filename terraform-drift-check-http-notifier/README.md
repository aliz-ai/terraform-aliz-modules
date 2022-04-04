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
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_scheduler_job.drift_check_schedule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) | resource |
| [google_cloudbuild_trigger.drift_check](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_logging_metric.drift_check_metric](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_metric) | resource |
| [google_monitoring_alert_policy.drift_check_alert](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_notification_channel.user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |
| [google_project_iam_member.drift_check_sa_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.drift_check_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket_iam_member.tfstate_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_compute_default_service_account.def_comp_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_default_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | The branch to check for drifts. | `string` | `"master"` | no |
| <a name="input_dir"></a> [dir](#input\_dir) | Directory, relative to the source root, in which to run the build. | `string` | `"."` | no |
| <a name="input_notified_email"></a> [notified\_email](#input\_notified\_email) | Email of the notified person or group. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | ID of the project to deploy the module into. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region of the resources. | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the repo to run the trigger on. | `string` | n/a | yes |
| <a name="input_repo_owner"></a> [repo\_owner](#input\_repo\_owner) | Owner of the repo to run the trigger on. | `string` | n/a | yes |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | The schedule to run the drift-check. | `string` | `"0 12 * * *"` | no |
| <a name="input_tfstate_bucket"></a> [tfstate\_bucket](#input\_tfstate\_bucket) | Name of the tfstate bucket. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Architecture Design


