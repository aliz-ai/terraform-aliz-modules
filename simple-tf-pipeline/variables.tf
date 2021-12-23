variable "include_build_id" {
  type        = bool
  description = "Switching this variable to true will require build id to apply a terraform plan"
  default     = false
}

variable "bucket_name_prefix" {
  type    = string
  default = "bucket-for-tf-plans"
}

variable "plan_retention_days" {
  type        = number
  description = "The number of days terraform plan files are kept in GCS"
  default     = 30
}

variable "storage_location" {
  type    = string
  default = "EU"
}

variable "project" {
  type = string
}

variable "github_owner" {
  type = string
}

variable "github_name" {
  type = string
}

variable "branches_to_plan_regex" {
  type    = string
  default = ".*"
}

variable "branches_to_apply_regex" {
  type    = string
  default = "main"
}

variable "working_directory" {
  type        = string
  description = "The path of the root terraform module inside the configured git repository"
  default     = "."
}

variable "trigger_name_suffix" {
  type        = string
  description = "Additional name suffix for multi-environment infrastructures"
  default     = "ops"
}

variable "terraform_image" {
  type = string
}
