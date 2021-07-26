resource "google_monitoring_alert_policy" "all_bgp_sessions_down" {

  count = var.all_bgp_sessions_down ? 1 : 0

  combiner = "OR"

  conditions {
    condition_threshold {
      aggregations {
        alignment_period     = "60s"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields      = ["resource.label.router_id"]
        per_series_aligner   = "ALIGN_MEAN"
      }

      comparison      = "COMPARISON_LT"
      duration        = var.all_bgp_sessions_down_duration
      filter          = "metric.type=\"router.googleapis.com/bgp/session_up\" resource.type=\"gce_router\""
      threshold_value = "1"

      trigger {
        count   = "1"
        percent = "0"
      }
    }

    display_name = "BGP session status by label.router_id [SUM]"
  }

  display_name = "All BGP Session Down"

  documentation {
    content   = var.all_bgp_sessions_down_documentation_content
    mime_type = "text/markdown"
  }

  enabled               = "true"
  notification_channels = var.all_bgp_sessions_down_notification_channels
  project               = var.project_id
}

resource "google_monitoring_alert_policy" "vpn_tunnels_down" {

  count = var.vpn_tunnels_down ? 1 : 0

  combiner = "OR"

  conditions {
    condition_threshold {
      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_MAX"
        per_series_aligner   = "ALIGN_MEAN"
      }

      comparison      = "COMPARISON_LT"
      duration        = "900s"
      filter          = "metric.type=\"vpn.googleapis.com/tunnel_established\" resource.type=\"vpn_gateway\""
      threshold_value = "1"

      trigger {
        count   = "1"
        percent = "0"
      }
    }

    display_name = "Tunnel established [MAX]"
  }

  display_name = "VPN Tunnels Down"

  documentation {
    content   = var.vpn_tunnels_down_documentation_content
    mime_type = "text/markdown"
  }

  enabled               = "true"
  notification_channels = var.vpn_tunnels_down_notification_channels
  project               = var.project_id
}

resource "google_monitoring_alert_policy" "bgp_session_down" {

  count = var.bgp_session_down ? 1 : 0

  combiner = "OR"

  conditions {
    condition_threshold {
      aggregations {
        alignment_period     = "60s"
        cross_series_reducer = "REDUCE_MAX"
        group_by_fields      = ["metadata.system_labels.name"]
        per_series_aligner   = "ALIGN_MEAN"
      }

      comparison      = "COMPARISON_GT"
      duration        = var.bgp_session_down_duration
      filter          = "metric.type=\"router.googleapis.com/bgp_sessions_down_count\" resource.type=\"gce_router\""
      threshold_value = "0"

      trigger {
        count   = "1"
        percent = "0"
      }
    }

    display_name = "BGP sessions down count by metadata.system_labels.name [MAX]"
  }

  display_name = "BGP Session Down"

  documentation {
    content   = var.bgp_session_down_documentation_content
    mime_type = "text/markdown"
  }

  enabled               = "true"
  notification_channels = var.bgp_session_down_notification_channels
  project               = var.project_id
}

resource "google_monitoring_alert_policy" "all_vpn_tunnels_down" {

  count = var.all_vpn_tunnels_down ? 1 : 0

  combiner = "OR"

  conditions {
    condition_threshold {
      aggregations {
        alignment_period     = "60s"
        cross_series_reducer = "REDUCE_MAX"
        group_by_fields      = ["metric.label.gateway_name"]
        per_series_aligner   = "ALIGN_MEAN"
      }

      comparison      = "COMPARISON_LT"
      duration        = "180s"
      filter          = "metric.type=\"vpn.googleapis.com/tunnel_established\" resource.type=\"vpn_gateway\""
      threshold_value = "1"

      trigger {
        count   = "1"
        percent = "0"
      }
    }

    display_name = "Tunnel established by label.gateway_name [MAX]"
  }

  display_name = "All VPN Tunnels Down"

  documentation {
    content   = var.all_vpn_tunnels_down_documentation_content
    mime_type = "text/markdown"
  }

  enabled               = "true"
  notification_channels = var.all_vpn_tunnels_down_notification_channels
  project               = var.project_id
}
