variable "project_id" {
  type        = string
  description = "The id of the project to use."
}

variable "project_number" {
  type        = string
  description = "The numberic code of the project to use."
}

variable "bigquery_location" {
  type        = string
  description = "The location for the BigQuery dataset"
  default     = "EU"
}