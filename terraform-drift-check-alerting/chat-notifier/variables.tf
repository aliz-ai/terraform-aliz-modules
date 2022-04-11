# universal variables
variable "project" {
  type        = string
  description = "ID of the project to deploy the module into."
}

variable "region" {
  type        = string
  description = "The region of the resources."
}

variable "tfstate_bucket" {
  type        = string
  description = "Name of the tfstate bucket."
}

variable "set_apis" {
  type        = bool
  description = "Let the module turn on the required APIs."
  default     = false
}

variable "config_bucket_location" {
  type        = string
  description = "The location of the storage bucket to store the notifier config"
}

variable "filter" {
  type        = string
  description = "The filter to be used by the notifier."
  default     = "build.status == Build.Status.FAILURE && build.build_trigger_id == \"${google_cloudbuild_trigger.drift_check.trigger_id}\""
}

# url secret
variable "url_secret_project" {
  type        = string
  description = "The project where the secret is stored if different than the default."
  default     = null
}

variable "url_secret_name" {
  type        = string
  description = "The name of the secret where the webhook url to the notified google chat space is stored."
}

variable "url_secret_version" {
  type        = string
  description = "The version of the secret."
  default     = "latest"
}

# cloud run
variable "image" {
  type        = string
  description = "Fully qualified id of the image from artifact repo."
}

# scheduler variables
variable "schedule" {
  type        = string
  description = "The schedule to run the drift-check."
  default     = "0 12 * * *"
}

# trigger variables
variable "repo_owner" {
  type        = string
  description = "Owner of the repo to run the trigger on."
}

variable "repo_name" {
  type        = string
  description = "Name of the repo to run the trigger on."
}

variable "branch_name" {
  type        = string
  description = "The branch to check for drifts."
  default     = "master"
}

variable "dir" {
  type        = string
  description = "Directory, relative to the source root, in which to run the build."
  default     = "."
}

# cloud run
variable "location" {
  type        = string
  description = "The location of service to be depoloyed to."
}