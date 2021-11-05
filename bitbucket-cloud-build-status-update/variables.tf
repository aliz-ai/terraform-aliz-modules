#Global variables
variable "project_id" {
  type = string
  description = "The id of the project where this stack will be deployed."
}

#Cloud Storage Bucket
variable "function_bucket_location" {
  type = string
  description = "Cloud Function Bucket location"
}

#PubSub
variable "topic_name" {
  type = string
  description = "PubSub Topic name for Log Sink to post logs which will trigger Cloud Function."
}

variable "logsink_name" {
  type = string
  description = "Name of the Sink posting build logs to PubSub."
}

#Cloud Function
variable "function_name" {
  type = string
  description = "Name of the Cloud Function."
}

variable "function_runtime" {
  type = string
  description = "Runtime in which the function is going to run."
  default = "python39"
}

variable "function_archive_name" {
  type        = string
  description = "Cloud function source code archive name. This file is the one that will be uploaded to Cloud Storage Bucket for Cloud Function Deployment"
  default     = "build-stat-resp.zip"
}

# function environmental variables
variable "bitbucket_username" {
  type = string
  description = "Bitbucket username with access to the repo."
}

variable "bitbucket_password" {
  type = string
  description = "Bitbucket password for user auth."
}

variable "bitbucket_owner" {
  type = string
  description = "Bitbucket repo owner for the API."
}

variable "bitbucket_repo" {
  type = string
  description = "Name of the bitbucket repo."
}