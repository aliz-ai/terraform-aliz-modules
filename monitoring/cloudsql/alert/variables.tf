variable "alert_project_id" {
  type = string
}

variable "cloud_sql_project_id" {
  type = string
}

variable "user_labels" {
  type = map(string)
}

variable "notification_channels" {
  type = list(string)
}