# notifier service account
resource "google_service_account" "drift_check_sa" {
  project      = var.project
  account_id   = "tf-drift-check-sa"
  display_name = "tf-drift-check-sa"
}

resource "google_project_service" "project" {
  for_each = var.set_apis ? toset([
    "logging.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudbuild.googleapis.com",
    "monitoring.googleapis.com"
  ]) : []
  project            = var.project
  service            = each.value
  disable_on_destroy = false
}

# service account roles
resource "google_project_iam_member" "drift_check_sa_roles" {
  role    = "roles/logging.logWriter"
  project = var.project
  member  = "serviceAccount:${google_service_account.drift_check_sa.email}"
}

resource "google_storage_bucket_iam_member" "tfstate_access" {
  bucket = var.tfstate_bucket
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${google_service_account.drift_check_sa.email}"
}