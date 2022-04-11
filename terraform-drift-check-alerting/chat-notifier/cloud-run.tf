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
