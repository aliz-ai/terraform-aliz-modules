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
  service_account = google_service_account.chat_notifier_sa.email
}
