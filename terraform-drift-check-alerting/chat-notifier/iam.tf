resource "google_storage_bucket_iam_member" "tfstate_access" {
  bucket = var.tfstate_bucket
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${google_service_account.chat_notifier_sa.email}"
}

resource "google_project_iam_member" "token_creator" {
  for_each = toset([
    "roles/iam.serviceAccountTokenCreator",
    "roles/logging.logWriter"
  ])
  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.chat_notifier_sa.email}"
}

data "google_service_account" "default_build_sa" {
  project    = var.project
  account_id = "${data.google_project.default.number}@cloudbuild.gserviceaccount.com"
}

resource "google_service_account_iam_member" "sa_user" {
  project            = var.project
  service_account_id = data.google_service_account.default_build_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.chat_notifier_sa.email}"
}