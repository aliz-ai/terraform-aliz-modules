resource "google_monitoring_uptime_check_config" "https" {
  display_name = "uptime-check ${var.host}"
  timeout      = "10s"
  period       = "60s"
  project      = var.project

  http_check {
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.monitored_project_id,
      host       = var.host
    }
  }

  content_matchers {
    content = "aliz.ai"
  }
}

resource "google_monitoring_alert_policy" "uptime-check-alert-policy" {
  for_each     = toset(var.duration)
  project      = var.project
  display_name = "uptime-check-alert-policy ${var.host} ${each.value}"
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

  notification_channels = var.notification_channels
  depends_on            = [google_monitoring_uptime_check_config.https]
}