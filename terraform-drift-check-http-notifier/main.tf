#notifier sa
resource "google_service_account" "drift_check_sa" {
  project      = var.project
  account_id   = "tf-drift-check-sa"
  display_name = "tf-drift-check-sa"
}

data "google_project" "project" {
  project_id = var.project
}

data "google_service_account" "default_cloudbuild" {
  project    = var.project
  account_id = "${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

#sa roles
resource "google_project_iam_member" "drift_check_sa_roles" {
  for_each = toset([
    #roles
    "roles/logging.logWriter",
    "roles/iam.serviceAccountTokenCreator"
  ])
  role    = each.value
  project = var.project
  member  = "serviceAccount:${google_service_account.drift_check_sa.email}"
}

resource "google_storage_bucket_iam_member" "tfstate_access" {
  bucket = var.tfstate_bucket
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.drift_check_sa.email}"
}

#cloud scheduler
data "google_compute_default_service_account" "def_comp_sa" {
  project = var.project
}

resource "google_cloud_scheduler_job" "drift_check_schedule" {
  name        = "drift-check"
  description = "Daily terraform drift-check."
  project     = var.project
  region      = var.region
  schedule    = var.schedule

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = "https://cloudbuild.googleapis.com/v1/projects/${var.project}/triggers/${google_cloudbuild_trigger.drift_check.name}:run"
    body        = base64encode("{\"branchName\":\"${var.branch_name}\"}")
    oauth_token {
      service_account_email = data.google_compute_default_service_account.def_comp_sa.email
    }
  }
}

#trigger - drift check
resource "google_cloudbuild_trigger" "drift_check" {
  project  = var.project
  name     = "terraform-drift-check"
  disabled = true

  github {
    owner = var.repo_owner
    name  = var.repo_name
    push {
      branch = var.branch_name
    }
  }

  build {
    step {
      name       = "hashicorp/terraform:1.1.0"
      entrypoint = "sh"
      dir        = var.dir
      args       = ["-c", "terraform init -no-color"]
    }
    step {
      name       = "hashicorp/terraform:1.1.0"
      entrypoint = "sh"
      dir        = var.dir
      args       = ["-c", "terraform plan -no-color -detailed-exitcode"]
    }
    timeout = "600s" # default 10 minutes
    options {
      logging              = "STACKDRIVER_ONLY"
      log_streaming_option = "STREAM_ON"
    }
  }
  service_account = google_service_account.drift_check_sa.id
}

# log-based alerting on audit-logs with trigger id filter
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

resource "google_monitoring_notification_channel" "user" {
  project      = var.project
  display_name = "email notification"
  type         = "email"
  labels = {
    email_address = "barnabas.hegedus@aliz.ai"
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
  /*
  alert_strategy {
    auto_close = "604800s"
  }
  */
  notification_channels = [
    google_monitoring_notification_channel.user.name
  ]
  depends_on = [
    google_logging_metric.drift_check_metric
  ]
}