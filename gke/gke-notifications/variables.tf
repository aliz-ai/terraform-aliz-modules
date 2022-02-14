variable "project_id" {
  type        = string
  description = "Project ID where this stack will be deployed."
}

variable "topic_name" {
  type        = string
  description = "PubSub Topic Name for accepting GKE notifications."
}

variable "function_bucket_name" {
  type        = string
  description = "Cloud Storage bucket name to store Cloud Functions source code."
}

variable "function_bucket_location" {
  type        = string
  description = "Cloud Storage bucket location to store Cloud Functions source code."
}

variable "function_archive_name" {
  type        = string
  description = "Cloud Functions source code archive name. This file is the one that will be uploaded to Cloud Storage bucket for the Cloud Function deployment."
  default     = "gke_notifications.zip"
}

variable "function_name" {
  type        = string
  description = "The name of the Cloud Function which will dispatch the GKE notifications."
}

variable "function_region" {
  type        = string
  description = "The region of the Cloud Function which will dispatch the GKE notifications."
}

variable "function_description" {
  type        = string
  description = "The description of the Cloud Function which will dispatch the GKE notifications."
  default     = "Cloud Function for handling GKE notifications."
}

variable "google_chat_webhook_url" {
  type        = string
  description = "Google Chat webhook URL where GKE notifications will be forwarded."
  default     = null
}

variable "slack_webhook_url" {
  type        = string
  description = "Slack webhook URL where GKE notifications will be forwarded."
  default     = null
}
