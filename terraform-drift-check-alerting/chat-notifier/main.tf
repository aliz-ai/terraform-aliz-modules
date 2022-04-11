# sa create
resource "google_service_account" "chat_notifier_sa" {
  project    = var.project
  account_id = "chat-notifier-sa"
}

# sa roles [sa user, run invoker]
resource "google_cloud_run_service_iam_member" "chat_notifier_sa_roles" {
  location = google_cloud_run_service.chat_notifier.location
  project  = var.project
  service  = google_cloud_run_service.chat_notifier.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.chat_notifier_sa.email}"
  depends_on = [
    google_cloud_run_service.chat_notifier
  ]
}

resource "google_storage_bucket_iam_member" "tfstate_access" {
  bucket = var.tfstate_bucket
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${data.google_project.default.number}@cloudbuild.gserviceaccount.com"
}

# pub/sub default token creator
data "google_project" "default" {
  project_id = var.project
}

resource "google_project_iam_member" "pubsub_token" {
  project = var.project
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${data.google_project.default.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

# pub/sub topic

resource "google_pubsub_topic" "build_status_tf" {
  project = var.project
  name    = "cloud-builds"
}

# pub/sub subscriber

resource "google_pubsub_subscription" "notifier" {
  project = var.project
  name    = "notifier-sub"
  topic   = google_pubsub_topic.build_status_tf.name

  push_config {
    push_endpoint = google_cloud_run_service.chat_notifier.status[0].url
    oidc_token {
      service_account_email = google_service_account.chat_notifier_sa.email
    }
  }
  depends_on = [
    google_cloud_run_service.chat_notifier,
    google_service_account.chat_notifier_sa,
    google_pubsub_topic.build_status_tf
  ]
}

# webhook url secret
data "google_secret_manager_secret" "webhook_url" {
  project   = var.url_secret_project != null ? var.url_secret_project : var.project
  secret_id = var.url_secret_name
}

data "google_secret_manager_secret_version" "webhook_url" {
  project = var.url_secret_project != null ? var.url_secret_project : var.project
  secret  = var.url_secret_name
  version = var.url_secret_version
}

resource "google_secret_manager_secret_iam_member" "webhook_url_access" {
  project   = var.project
  secret_id = data.google_secret_manager_secret.webhook_url.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_project.default.number}-compute@developer.gserviceaccount.com"
}

# config
resource "random_id" "suffix" {
  byte_length = 2
}

resource "google_storage_bucket" "notifier_config_bucket" {
  location                    = "EU"
  project                     = var.project
  name                        = "notifier-config-tf-${random_id.suffix.hex}"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "notifier_config" {
  name    = "config.yaml"
  bucket  = google_storage_bucket.notifier_config_bucket.name
  content = <<-EOF
apiVersion: cloud-build-notifiers/v1
kind: GoogleChatNotifier
metadata:
  name: example-googlechat-notifier
spec:
  notification:
    filter: ${var.filter}
    delivery:
      webhookUrl:
        secretRef: webhook-url
  secrets:
  - name: webhook-url
    value: ${data.google_secret_manager_secret_version.webhook_url.name}
  EOF
  depends_on = [
    google_secret_manager_secret_version.webhook_url_version
  ]
}

# cloud run service
resource "google_cloud_run_service" "chat_notifier" {
  project  = var.project
  name     = "chat-notifier"
  location = "europe-west1"

  template {
    spec {
      containers {
        image = var.image
        env {
          name  = "CONFIG_PATH"
          value = "gs://${google_storage_bucket.notifier_config_bucket.name}/${google_storage_bucket_object.notifier_config.name}" # path to config storage object
        }
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "run_all_users" {
  project  = var.project
  service  = google_cloud_run_service.chat_notifier.name
  location = google_cloud_run_service.chat_notifier.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.chat_notifier_sa.email}"
}

# cloud scheduler

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

# scheduled trigger

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
  }
}
