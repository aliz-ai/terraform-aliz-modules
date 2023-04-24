locals {

}

resource "google_monitoring_notification_channel" "pagerduty" {
  display_name = var.notification_channel.display_name
  type         = "pagerduty"
  labels       = var.notification_channel.labels

  sensitive_labels {
    service_key = var.notification_channel.service_key
  }
}

resource "google_monitoring_alert_policy" "uptime-check-alert-policy" {
  for_each     = toset(var.duration)
  project      = var.project
  display_name = local.alert_filters[each.key]
  combiner     = "OR"
  conditions {
    display_name = "uptime-check ${var.host}"
    condition_threshold {
      filter          = format("metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"%s\" AND resource.type=\"uptime_url\"", google_monitoring_uptime_check_config.https.uptime_check_id)
      duration        = each.value
      comparison      = "COMPARISON_GT"
      threshold_value = "1"

      trigger {
        count = 1
      }
      aggregations {
        group_by_fields      = ["resource.label.*"]
        alignment_period     = "1200s"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
      }
    }
  }

  notification_channels = google_monitoring_notification_channel.pagerduty[*].name
  depends_on            = [google_monitoring_notification_channel.pagerduty]
}
