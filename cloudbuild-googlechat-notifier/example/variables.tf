variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "github_owner" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "webhook_secret_ref" {
  type = string
}