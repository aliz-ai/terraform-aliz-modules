variable "project_id" {
  type        = string
  description = "The ID of the monitoring project where the audit logs are collected and the resources will be created."
}

variable "notification_channel" {
  type = object({
    display_name = string
    service_key  = string
    labels       = map(string)
  })
}

variable "org_root_permissions" {
  type = bool
  # fix description
  description = "Whether to enable the Org Root Permissions alerting rule."
  default     = false
}

variable "super_admin_auth" {
  type = object({
    enabled     = bool
    admin_email = string
  })
  description = "Whether to enable the Super Admin Auth alerting rule."
  default = {
    enabled     = false
    admin_email = ""
  }
}

variable "cloud_identity_config_change" {
  type        = bool
  description = "Whether to enable the Cloud Identity Config Change alerting rule."
  default     = false
}

variable "api_client_access_change" {
  type        = bool
  description = "Whether to enable the API Client Access Change alerting rule."
  default     = false
}

variable "org_admin_role_grant" {
  type        = bool
  description = "Whether to enable the Org Admin Role Grant alerting rule."
  default     = false
}

variable "add_member_to_admin_group" {
  type = object({
    enabled           = bool
    admin_group_email = string
  })
  description = "Whether to enable the Add Member to Admin Group alerting rule."
  default = {
    enabled           = false
    admin_group_email = ""
  }
}

variable "delete_super_admin" {
  type = object({
    enabled     = bool
    admin_email = string
  })
  description = "Whether to enable the Delete Super Admin alerting rule."
  default = {
    enabled     = false
    admin_email = ""
  }
}
# fix later
variable "remove_member_from_admin_group" {
  type = object({
    enabled           = bool
    admin_group_email = string
  })
  description = "Whether to enable the Remove Member from Admin Group alerting rule."
  default = {
    enabled           = false
    admin_group_email = ""
  }
}

variable "service_account_or_key_create" {
  type        = bool
  description = "Whether to enable the Service Account or Key Create alerting rule."
  default     = false
}

variable "public_access_on_resource" {
  type        = bool
  description = "Whether to enable the Public Access on Resource alerting rule."
  default     = false
}

variable "add_ssh_key_to_metadata" {
  type        = bool
  description = "Whether to enable the Add SSH Key to Metadata alerting rule."
  default     = false
}

variable "org_or_folder_iam_change" {
  type        = bool
  description = "Whether to enable the Org or Folder IAM Change alerting rule."
  default     = false
}

variable "scc_findings_notifiaction" {
  type        = bool
  description = "Whether to enable the SCC Findings Notification alerting rule."
  default     = false
}

variable "org_log_sinks_modification" {
  type        = bool
  description = "Whether to enable the Org Log Sinks Modification alerting rule."
  default     = false
}

variable "pubsub_destination_modification" {
  type        = bool
  description = "Whether to enable the Pub/Sub Destination Modification alerting rule."
  default     = false
}

variable "enable_api_for_unaproved_service" {
  type        = bool
  description = "Whether to enable the Enable API for Unapproved Service alerting rule."
  default     = false
}

variable "modified_org_policy" {
  type        = bool
  description = "Whether to enable the Modified Org Policy alerting rule."
  default     = false
}

variable "resource_created_outside_pipeline" {
  type        = bool
  description = "Whether to enable the Resource Created Outside Pipeline alerting rule."
  default     = false
}

variable "packet_mirroring_enabled_or_modified" {
  type        = bool
  description = "Whether to enable the Packet Mirroring Enabled or Modified alerting rule."
  default     = false
}

variable "public_firewall_rule_created" {
  type        = bool
  description = "Whether to enable the Public Firewall Rule Created alerting rule."
  default     = false
}

variable "sensitive_ports_opened_to_public" {
  type        = bool
  description = "Whether to enable the Sensitive Ports Opened to Public alerting rule."
  default     = false
}

variable "new_external_route_added" {
  type        = bool
  description = "Whether to enable the New External Route Added alerting rule."
  default     = false
}

variable "network_logs_disabled" {
  type        = bool
  description = "Whether to enable the Network Logs Disabled alerting rule."
  default     = false
}

variable "data_access_logs_disabled" {
  type        = bool
  description = "Whether to enable the Data Access Logs Disabled alerting rule."
  default     = false
}
