variable "project_id" {
  type        = string
  description = "The id of the project to use."
}

variable "region" {
  type        = string
  description = "The region to put the Cloud Run service and Storage buckets into"
}

variable "config_file_bucket" {
  type        = string
  description = "The name of the GCS bucket to put the config file into. If empty, a new one will be created."
  default     = ""
}

variable "build_filter" {
  type        = string
  description = "CEL filter expression to filter for specific builds and statuses. See https://cloud.google.com/build/docs/configuring-notifications/configure-googlechat#using_cel_to_filter_build_events for details and examples."
}

variable "webhook_secret_ref" {
  type        = string
  description = "The fully qualified name of the secret Webhook URL (projects/{}/secrets/{}/versions/{})"
}

variable "service_account_email" {
  type        = string
  description = "The email address of the service account to be used with Cloud Run. If left empty, a new account will be created."
  default     = ""
}

variable "grant_secret_permission" {
  type        = bool
  description = "Whether to grant Secret Accessor permission for the service account on the webhook url secret. This is needed for proper operation, but your pipelines might be managing these on their own"
  default     = true
}

variable "grant_bucket_permission" {
  type        = bool
  description = "Whether to grant Object viewer permission on the config bucket. This is needed for proper operation, but your pipelines might be managing these on their own"
  default     = true
}

variable "grant_pubsub_sa_permission" {
  type        = bool
  description = "Whether to grant SA token creator role on the project for the Pub/Sub service account. This is needed for proper operation, but your pipelines might be managing these on their own"
  default     = true
}

variable "grant_run_invoker_permission" {
  type        = bool
  description = "Whether to grant Cloud Run invoker permission for the SA. This is needed for proper operation, but your pipelines might be managing these on their own"
  default     = true
}

variable "grant_sa_act_as_for" {
  type        = string
  description = "The (service) account provisioning this module needs `iam.serviceaccounts.actAs` permission on the `service_account_email` (or the created service account). By specifying that acting service account here, this module will try to grant that permission"
  default     = ""
}