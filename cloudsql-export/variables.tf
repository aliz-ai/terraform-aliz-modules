# Generic variables
variable "project_id" {
  type        = string
  description = "Project ID where this stack should be deployed"
}

variable "cloud_scheduler_region" {
  type        = string
  description = "Region to deploy Cloud Scheduler. This should be the same region with your app engine region"
}

# Label related variables

variable "label_environment" {
  type        = string
  description = "label environment"
  default     = "production"
}

# The following variables will be used to create JSON data for Cloud Scheduler to be sent to Cloud PubSub
variable "cloudsql_database_names" {
  type        = list(string)
  description = "List of databases to be backup"
}

variable "cloudsql_instance_name" {
  type        = string
  description = "Cloud SQL instance name to be backup"
}

variable "cloudsql_project_id" {
  type        = string
  description = "Cloud SQL instance project id to be backup"
}

variable "backup_bucket" {
  type        = string
  description = "Cloud Storage bucket name to store SQL export"
}

# Google PubSub variables

variable "topic_name" {
  type        = string
  description = "PubSub Topic Name for Cloud Scheduler to post scheduler data which will trigger Cloud Function"
}

# Google Cloud Scheduler variables

variable "cloud_scheduler_name" {
  type        = string
  description = "Name of the cloud scheduler used to Schdule Cloud SQL Export"
}

variable "cloud_scheduler_description" {
  type        = string
  description = "Description of the cloud scheduler used to schedule Cloud SQL export."
}

variable "cloud_scheduler_schedule" {
  type        = string
  description = "Schedule of the Cloud SQL export (in crontab format)"
}

variable "cloud_scheduler_time_zone" {
  type        = string
  description = "Time zone of the cloud scheduler"
}

variable "function_bucket_name" {
  type        = string
  description = "Cloud Storage Bucket Name to store Cloud Functions source code"
}

variable "function_bucket_location" {
  type        = string
  description = "Cloud Storage Bucket location to store Cloud Functions source code"
}

variable "function_archive_name" {
  type        = string
  description = "Cloud function source code archive name. This file is the one that will be uploaded to Cloud Storage Bucket for Cloud Function Deployment"
  default     = "cloudsql_exporter.zip"
}

variable "function_memory_mb" {
  type        = string
  description = "Memory (in MB), available to the function. Default value is 128."
  default     = "128"
}

variable "function_runtime" {
  type        = string
  description = "The runtime in which the function is going to run. "
  default     = "python38"
}

variable "function_name" {
  type        = string
  description = "Cloud function name for Cloud SQL data export"
  default     = "cloudsql-data-export"
}

variable "function_description" {
  type        = string
  description = "Cloud function description"
  default     = "Cloud SQL schduled export to Cloud Storage"
}

variable "function_service_account_id" {
  type        = string
  description = "Service account id that will be used by Cloud Function."
}

variable "function_service_account_name" {
  type        = string
  description = "Custom IAM service account name that will be used by Cloud Function."
  default     = ""
}

variable "function_role_id" {
  type        = string
  description = "The camel case role id to use for this role. Cannot contain - characters."
}

variable "function_role_title" {
  type        = string
  description = "A human-readable title for the role."
}

variable "function_role_description" {
  type        = string
  description = "A human-readable description for the role."
  default     = ""
}

variable "export_object_suffix" {
  type        = string
  default     = ""
}
