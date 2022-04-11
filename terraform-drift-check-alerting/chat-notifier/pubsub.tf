
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

resource "google_project_iam_member" "pubsub_token" {
  project = var.project
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${data.google_project.default.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}