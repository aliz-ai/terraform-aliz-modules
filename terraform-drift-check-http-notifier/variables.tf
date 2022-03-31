# global variables
variable "project" {
  type        = string
  description = "ID of the project to deploy the module into."
}

variable "region" {
  type        = string
  description = "The region of the resources."
}

# scheduler variables
variable "schedule" {
  type        = string
  description = "The schedule to run the drift-check."
  default     = "0 12 * * *"
}

variable "branch_name" {
  type        = string
  description = "The branch to check for drifts."
  default     = "master"
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

variable "dir" {
  type        = string
  description = "Directory, relative to the source root, in which to run the build."
  default     = "."
}