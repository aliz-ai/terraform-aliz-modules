#Global variables
variable "project_id" {
  type        = string
  description = "The id of the project where this stack will be deployed."
}

variable "project_location" {
  type        = string
  description = "Cloud Storage Bucket location to store Cloud Function source code."
}

#PubSub
variable "topic_name" {
  type        = string
  description = "PubSub Topic name for Log Sink to post logs which will trigger Cloud Function."
  default     = "bitbucket_build_logs"
}

variable "logsink_name" {
  type        = string
  description = "Name of the Sink posting build logs to PubSub."
  default     = "bitbucket_build_logs"
}

#Cloud Function
variable "function_name" {
  type        = string
  description = "Name of the Cloud Function."
  default     = "bitbucket-build-status-update"
}

variable "function_description" {
  type        = string
  description = "Description for the function."
  default     = "Cloud build status response to Bitbucket"
}

variable "function_runtime" {
  type        = string
  description = "Runtime in which the function is going to run."
  default     = "python39"
}

variable "function_memory_mb" {
  type        = string
  description = "Memory (in MB), available to the function. Default value is 128."
  default     = "128"
}

variable "function_archive_name" {
  type        = string
  description = "Cloud function source code archive name. This file is the one that will be uploaded to Cloud Storage Bucket for Cloud Function Deployment"
  default     = "build-stat-resp.zip"
}

# function environmental variables
variable "bitbucket_key" {
  type        = string
  description = "Bitbucket OAuth key"
}

variable "bitbucket_secret" {
  type        = string
  description = "Bitbucket OAuth secret"
}
variable "bitbucket_owner" {
  type        = string
  description = "Bitbucket repo owner for the API."
}

variable "bitbucket_repo" {
  type        = string
  description = "Name of the bitbucket repo."
}