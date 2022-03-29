#notifier sa
resource "google_service_account" "drift_check_sa" {
  project = var.project
  account_id = "tf-drift-check-sa"
  display_name = "tf-drift-check-sa"
}

#sa roles (pubsub, cloud run)
resource "google_service_account_iam_member" "drift_check_sa_roles" {
  for_each = toset([
    #roles
    "roles/run.invoker"
  ])
  project = var.project
  member = google_service_account.drift_check_sa.email
}

#cloud scheduler
data "google_compute_default_service_account" "def_comp_sa" {
  project = var.project
}

resource "google_cloud_scheduler_job" "drift_check_schedule" {
  name = "drift-check"
  description = "Daily terraform drift-check."
  project = var.project
  region = var.region
  schedule = var.schedule
  
  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri = "https://cloudbuild.googleapis.com/v1/projects/${var.project}/triggers/${google_cloudbuild_trigger.drift_check.name}:run"
    body = base64encode({"branchName":"${var.branch_name}"})
    oauth_token {
      service_account_email = data.google_compute_default_service_account.def_comp_sa.email
    }
  }
}

#trigger - drift check
resource "google_cloudbuild_trigger" "drift_check" {
  project = var.project
  name = "terraform-drift-check"
  disabled = true

  github {
    owner = var.repo_owner
    name = var.repo_name
    push {
      branch = var.branch_name
    }
  }

  build {
    step {
      name = "hashicorp/terraform:1.1.0"
      entrypoint = "sh"
      dir = var.dir
      args = [ "-c", "terraform init -no-color"]
    }
    step {
      name = "hashicorp/terraform:1.1.0"
      entrypoint = "sh"
      dir = var.dir
      args = [ "-c", "terraform plan -no-color -detailed-exitcode"]
    }
    timeout = "600s" # default 10 minutes
  }
}

#cloud run
resource "google_cloud_run_service" "http_notifier" {
  project = var.project
  location = var.location
  name = "http-notifier"
  template {
    metadata {
      name = "failed-plan-http-notifier"
    }
    spec {
      containers {
        image = "us-east1-docker.pkg.dev/gcb-release/cloud-build-notifiers/http:latest"
        env {
          name = "CONFIG_PATH"
          value = google_storage_bucket_object.notifier_config.self_link
        }
      }
      service_account_name = google_service_account.drift_check_sa.email
    }
  }
  depends_on = [
    google_storage_bucket_object.notifier_config
  ]
}

resource "google_storage_bucket" "notifier_config" {
  project = var.project
  location = var.location
  name = "http-notifier-config-${random_id.resource_suffix.hex}"
}

resource "google_storage_bucket_iam_member" "drift_check_sa" {
  bucket = google_storage_bucket.notifier_config.id
  role = "roles/storage.objectReader"
  member = "serviceAccount:${google_service_account.drift_check_sa.email}"
}

resource "google_storage_bucket_object" "notifier_config" {
  bucket = google_storage_bucket.notifier_config.name
  name = "http-notifier.yaml"
  content = <<EOF
  apiVersion: cloud-build-notifiers/v1
  kind: GoogleChatNotifier
  metadata:
    name: failed-plan-googlechat-notifier
  spec:
    notification:
      filter: ${var.filter}
      delivery:
        url: url
  EOF
}

resource "random_id" "resource_suffix" {
  byte = 2
}

#pubsub topic
resource "google_pubsub_topic" "cloud_builds_status" {
  project = var.project
  name = "cloud-builds-status"
}

resource "google_pubsub_subscription" "cloud_builds_status" {
  project = var.project
  name = "cloud-builds-status-subscription"
  push_config {
    push_endpoint = google_cloud_run_service.http_notifier.url
    oidc_token {
      service_account_email = google_service_account.drift_check_sa.email
    }
  }
}