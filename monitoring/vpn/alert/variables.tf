variable "project_id" {
  type = string
}

# bgp_session_down

variable "bgp_session_down_enabled" {
  type = string
  default = "true"
  description = "Switch for BGP Session Down Alert"
}

variable "bgp_session_down_duration" {
  type    = string
  default = "900s"
  description = "The amount of time that a time series must violate the threshold to be considered failing. Currently, only values that are a multiple of a minute--e.g., 0, 60, 120, or 300 seconds--are supported."
}

variable "bgp_session_down_notification_channels" {
  type = list(string)
  description = "List of notification channel for BGP Session Down alert"
}

variable "bgp_session_down_documentation_content" {
  type    = string
  default = "See docs"
  description = "Documentation that is included with notifications and incidents related to this policy."
}


# all_bgp_session_down


variable "all_bgp_sessions_down_enabled" {
  type = string
  default = "true"
  description = "Switch for All BGP Sessions Down Alert"
}

variable "all_bgp_sessions_down_duration" {
  type    = string
  default = "180s"
  description = "The amount of time that a time series must violate the threshold to be considered failing. Currently, only values that are a multiple of a minute--e.g., 0, 60, 120, or 300 seconds--are supported."
}

variable "all_bgp_sessions_down_notification_channels" {
  type = list(string)
  description = "List of notification channels for All BGP Sessions Down Alert"
}

variable "all_bgp_sessions_down_documentation_content" {
  type    = string
  default = "See docs"
  description = "Documentation that is included with notifications and incidents related to this policy."
}


# vpn_tunnels_down

variable "vpn_tunnels_down_enabled" {
  type = string
  default = "true"
  description = "Switch for VPN Tunnels Down Alert"
}

variable "vpn_tunnels_down_duration" {
  type    = string
  default = "900s"
  description = "The amount of time that a time series must violate the threshold to be considered failing. Currently, only values that are a multiple of a minute--e.g., 0, 60, 120, or 300 seconds--are supported."
}

variable "vpn_tunnels_down_notification_channels" {
  type = list(string)
  description = "List of notification channel for VPN Tunnels Down alert"
}

variable "vpn_tunnels_down_documentation_content" {
  type    = string
  default = "See docs"
  description = "Documentation that is included with notifications and incidents related to this policy."
}


# all_vpn_tunnels_down

variable "all_vpn_tunnels_down_enabled" {
  type = string
  default = "true"
  description = "Switch for All VPN Tunnels Down Alert"  
}

variable "all_vpn_tunnels_down_duration" {
  type    = string
  default = "180s"
  description = "The amount of time that a time series must violate the threshold to be considered failing. Currently, only values that are a multiple of a minute--e.g., 0, 60, 120, or 300 seconds--are supported."
}

variable "all_vpn_tunnels_down_notification_channels" {
  type = list(string)
  description = "List of notification channel for All VPN Tunnels Down aleert"
}

variable "all_vpn_tunnels_down_documentation_content" {
  type    = string
  default = "See docs"
  description = "Documentation that is included with notifications and incidents related to this policy."  
}
