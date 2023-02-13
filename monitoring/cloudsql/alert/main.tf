locals {
  user_labels_filter = join(" AND ", [for key, value in var.user_labels : "metadata.user_labels.${key} = \"${value}\""])
  common_filter_parts = [
    "resource.type = \"cloudsql_database\"",
    "resource.labels.project_id = \"${var.cloud_sql_project_id}\"",
    length(local.user_labels_filter) > 0 ? "(${local.user_labels_filter})" : ""
  ]
  common_filter = join(" AND ", compact(local.common_filter_parts))
}

resource "google_monitoring_alert_policy" "cloud_sql_cpu_utilization" {
  project               = var.alert_project_id
  display_name          = "Cloud SQL CPU utilization in ${var.cloud_sql_project_id}"
  combiner              = "OR"
  notification_channels = var.notification_channels
  conditions {
    display_name = "Cloud SQL Database - CPU utilization"
    condition_threshold {
      filter = "${local.common_filter} AND metric.type = \"cloudsql.googleapis.com/database/cpu/utilization\""
      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_NONE"
        per_series_aligner   = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "300s"
      trigger {
        count = 1
      }
      threshold_value = 0.8
    }
  }
}

resource "google_monitoring_alert_policy" "cloud_sql_disk_utilization" {
  project               = var.alert_project_id
  display_name          = "Cloud SQL Disk utilization in ${var.cloud_sql_project_id}"
  combiner              = "OR"
  notification_channels = var.notification_channels
  conditions {
    display_name = "Cloud SQL Database - Disk utilization"
    condition_threshold {
      filter = "${local.common_filter} metric.type = \"cloudsql.googleapis.com/database/disk/utilization\""
      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_NONE"
        per_series_aligner   = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      trigger {
        count = 1
      }
      threshold_value = 0.9
    }
  }
}

resource "google_monitoring_alert_policy" "cloud_sql_memory_utilization" {
  project               = var.alert_project_id
  display_name          = "Cloud SQL Memory utilization in ${var.cloud_sql_project_id}"
  combiner              = "OR"
  notification_channels = var.notification_channels
  conditions {
    display_name = "Cloud SQL Database - Memory utilization"
    condition_threshold {
      filter = "${local.common_filter} AND metric.type = \"cloudsql.googleapis.com/database/memory/utilization\""
      aggregations {
        alignment_period     = "3600s"
        cross_series_reducer = "REDUCE_NONE"
        per_series_aligner   = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      trigger {
        count = 1
      }
      threshold_value = 0.9
    }
  }
}

resource "google_monitoring_alert_policy" "cloud_sql_instance_up" {
  project               = var.alert_project_id
  display_name          = "Cloud SQL Instance up in ${var.cloud_sql_project_id}"
  combiner              = "OR"
  enabled               = true
  notification_channels = var.notification_channels
  conditions {
    display_name = "Cloud SQL Database - Instance up"
    condition_absent {
      filter = "${local.common_filter} AND metric.type = \"cloudsql.googleapis.com/database/up\""
      aggregations {
        alignment_period     = "60s"
        cross_series_reducer = "REDUCE_NONE"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
      }
      duration = "180s"
      trigger {
        count = 1
      }
    }
  }
}