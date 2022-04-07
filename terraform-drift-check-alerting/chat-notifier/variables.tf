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

# cloud run
variable "chat_url" {
  type        = string
  description = "The webhook url to the notified google chat space."
}

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
  type = string
}