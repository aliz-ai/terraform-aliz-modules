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
