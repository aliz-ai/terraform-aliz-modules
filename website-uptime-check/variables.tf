variable "project" {
  type        = string
  description = "the ID of the project in wich the resource belongs"
}

variable "monitored_project_id" {
  type        = string
  description = "project_id of the monitored resource"
}

variable "host" {
  type        = string
  description = "Hostname or IP adress of the check"
}

variable "notification_channels" {
  type        = list(string)
  description = "List of notification channels"
}

variable "duration" {
  type        = list(string)
  description = "Duration of the uptime check"
  default     = ["60s"]
}