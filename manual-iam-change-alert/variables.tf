variable "org_id" {
  type        = string
  description = "The organization ID"
}

variable "infra_service_account" {
  type        = string
  description = "The service account used by the infra project. IAM Changes made by this account will be excluded from the alerts"
}

variable "project" {
  type        = string
  description = "The ID of the project to use."
}

variable "region" {
  type        = string
  description = "The region to be used for the function."
}

variable "webhook_secret" {
  type        = string
  description = "The fully qualified ID (projects/<number>/secrets/<name>/versions/<version>) of the secret version where the full webhook URL is stored (including the keys). The secret needs to be created manually"
}