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