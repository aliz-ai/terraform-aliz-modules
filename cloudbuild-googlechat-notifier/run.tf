resource "google_cloud_run_service" "default" {
  name     = "build-notifier-${random_id.suffix.hex}"
  project  = var.project_id
  location = var.region
  template {
    spec {
      containers {
        image = "us-east1-docker.pkg.dev/gcb-release/cloud-build-notifiers/googlechat:latest"
        env {
          name  = "CONFIG_PATH"
          value = "gs://${local.config_bucket_name}/${google_storage_bucket_object.config.name}"
        }
        env {
          name  = "PROJECT_ID"
          value = var.project_id
        }
      }
      service_account_name = local.cloudrun_service_account
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}