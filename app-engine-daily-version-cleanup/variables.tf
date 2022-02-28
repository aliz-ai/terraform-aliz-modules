variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "github_owner" {
  type    = string
  default = "aliz-ai"
}

variable "github_name" {
  type = string
}

variable "branches_to_apply_regex" {
  type    = string
  default = "master"
}