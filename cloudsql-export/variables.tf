# Google PubSub variables
variable "topic_name" {
  type = string
}

# Google Cloud Schduler variables

variable "cloud_scheduler_name" {
  type = string
}

variable "cloud_scheduler_description" {
  type    = string
  default = "CloudSQL export schedule"
}

variable "cloud_scheduler_schedule" {
  type = string
}

# Google Cloud Storage Variables

variable "bucket_name" {
  type        = string
  description = "Google Cloud Storage Bucket name used to store CloudSQL export"
}

variable "bucket_location" {
  type        = string
  description = "Bucket location. See https://cloud.google.com/storage/docs/locations for list of possible location"
}

variable "bucket_force_destroy" {
  type        = bool
  description = "Force remove all objects inside a bucket when deleting the bucket. "
  default     = false
}

variable "bucket_uniform_bucket_level_access" {
  type        = bool
  description = "Enable uniform bucket-level access to a bucket"
  default     = true
}

# Label related variables

variable "label_environment" {
  type        = string
  description = "label environment"
  default     = "production"
}

variable "function_bucket_name" {
  type = string
}

variable "function_source_dir" {
  type    = string
}

variable "function_archive_name" {
  type    = string
  default = "gcf_cloudsql_exporter.zip"
}

variable "function_memory_mb" {
  type    = string
  default = "128"
}

variable "function_runtime" {
  type    = string
  default = "python38"
}

variable "function_description" {
  type    = string
  default = "scheduled export to cloud storage for cloudsql"
}

variable "function_name" {
  type    = string
  default = "cloudsql-exporter"
}

variable "region" {
  type = string
}

variable "cloud_scheduler_region" {
  type = string
}


variable "database_name" {
  type = string
}

variable "cloudsql_instance_name" {}
variable "backup_bucket" {}
variable "cloud_schduler_time_zone" {}

variable "project_id" {}