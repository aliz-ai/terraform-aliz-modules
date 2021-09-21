resource "google_monitoring_notification_channel" "main" {
  display_name = ""
  type         = "email"
  labels = {
    email_address = ""
  }
  project = local.project_id
}

module "vpn-alert" {

  source = "../"

  project_id = local.project_id

  all_bgp_sessions_down = "true"
  all_bgp_sessions_down_notification_channels = [
    google_monitoring_notification_channel.main.name
  ]

  vpn_tunnels_down = "true"
  vpn_tunnels_down_notification_channels = [
    google_monitoring_notification_channel.main.name
  ]

  bgp_session_down = "true"
  bgp_session_down_notification_channels = [
    google_monitoring_notification_channel.main.name
  ]

  all_vpn_tunnels_down = "true"
  all_vpn_tunnels_down_notification_channels = [
    google_monitoring_notification_channel.main.name
  ]
}