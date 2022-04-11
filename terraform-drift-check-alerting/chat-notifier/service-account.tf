resource "google_service_account" "chat_notifier_sa" {
  project    = var.project
  account_id = "chat-notifier-sa"
}


resource "google_cloud_run_service_iam_member" "chat_notifier_sa_roles" {
  location = google_cloud_run_service.chat_notifier.location
  project  = var.project
  service  = google_cloud_run_service.chat_notifier.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.chat_notifier_sa.email}"
  depends_on = [
    google_service_account.chat_notifier_sa,
    google_cloud_run_service.chat_notifier
  ]
}
