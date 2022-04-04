# GCP Cloudbuild pipeline and alerting for Terraform drift check

## Overview

The purpose of this module is to check for drifts in a terraform managed GCP environment.

The solution relies on the audit logs written by Cloud Build to Cloud Logging to detect certain build events. The audit log is counted toward an alert policy with a custom logs-based metric. In case of a failed check (detected drift), the alert policy sends an email alert to the provided email adress (single person or group). The pipeline is triggered with a customizable Cloud Scheduler Job.
  
Created resources:
* Cloud Scheduler Job
* Cloud Build Trigger
* Logs-based Metric
* Alert Policy

## Required Resources

The following resources should be created and configured properly prior to running this module.

1. Notification Channel (email)

### Installation Dependencies

### Enable APIs

* Cloud Logging : `logging.googleapis.com`
* Cloud Build API : `cloudbuild.googleapis.com`
* Cloud Scheduler : `cloudscheduler.googleapis.com`
* Cloud Monitoring : `monitoring.googleapis.com`

If the deployer has the required permissions, the module can enable the required APIs.

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
| [google_project_iam_member.drift_check_sa_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.drift_check_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket_iam_member.tfstate_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_compute_default_service_account.def_comp_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_default_service_account) | data source |
| [google_monitoring_notification_channel.notif_target](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/monitoring_notification_channel) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | The branch to check for drifts. | `string` | `"master"` | no |
| <a name="input_dir"></a> [dir](#input\_dir) | Directory, relative to the source root, in which to run the build. | `string` | `"."` | no |
| <a name="input_notif_project"></a> [notif\_project](#input\_notif\_project) | The project the notification channel is located in. If it's the same, then ommit assignment. | `string` | `null` | no |
| <a name="input_notified_email"></a> [notified\_email](#input\_notified\_email) | Email of the notified person or group. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | ID of the project to deploy the module into. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region of the resources. | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the repo to run the trigger on. | `string` | n/a | yes |
| <a name="input_repo_owner"></a> [repo\_owner](#input\_repo\_owner) | Owner of the repo to run the trigger on. | `string` | n/a | yes |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | The schedule to run the drift-check. | `string` | `"0 12 * * *"` | no |
| <a name="input_set_apis"></a> [set\_apis](#input\_set\_apis) | Let the module turn on the required APIs. | `bool` | `false` | no |
| <a name="input_tfstate_bucket"></a> [tfstate\_bucket](#input\_tfstate\_bucket) | Name of the tfstate bucket. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Architecture Design


