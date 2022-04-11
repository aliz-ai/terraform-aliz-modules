resource "google_logging_metric" "drift_check_metric" {
  project = var.project
  name    = "drift-check-tf"
  filter  = "severity=ERROR\nresource.labels.build_trigger_id=${google_cloudbuild_trigger.drift_check.trigger_id}"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

data "google_monitoring_notification_channel" "notif_target" {
  project = var.notif_project == null ? var.project : var.notif_project
  type    = "email"
  labels = {
    email_address = var.notified_email
  }
}

resource "google_monitoring_alert_policy" "drift_check_alert" {
  project      = var.project
  display_name = "drift-check-alert-policy"
  combiner     = "OR"
  enabled      = true
  conditions {
    display_name = "drift-check-log-filter"
    condition_threshold {
      aggregations {
        alignment_period     = "60s"
        cross_series_reducer = "REDUCE_MAX"
        per_series_aligner   = "ALIGN_MAX"
      }
      comparison = "COMPARISON_GT"
      duration   = "0s"
      filter     = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.drift_check_metric.name}\" resource.type=\"build\""
      trigger {
        percent = 100
      }
    }
  }

  notification_channels = [
    data.google_monitoring_notification_channel.notif_target.name
  ]

  depends_on = [
    google_logging_metric.drift_check_metric
  ]
}