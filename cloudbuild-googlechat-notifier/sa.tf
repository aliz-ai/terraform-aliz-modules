locals {
  create_service_account   = var.service_account_email == ""
  cloudrun_service_account = local.create_service_account ? google_service_account.cloudrun_sa[0].email : var.service_account_email
}

resource "google_service_account" "cloudrun_sa" {
  count      = local.create_service_account ? 1 : 0
  project    = var.project_id
  account_id = "cbgcn-sa-${random_id.suffix.hex}"
}

resource "google_service_account_iam_member" "cloudrun_sa_actas" {
  count              = local.create_service_account && var.grant_sa_act_as_for != "" ? 1 : 0
  service_account_id = google_service_account.cloudrun_sa[0].name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${var.grant_sa_act_as_for}"
}

resource "google_secret_manager_secret_iam_member" "sa_secret_iam" {
  count     = var.grant_secret_permission ? 1 : 0
  project   = split("/", var.webhook_secret_ref)[1]
  secret_id = replace(var.webhook_secret_ref, "/\\/versions\\/\\d+/", "")
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${local.cloudrun_service_account}"
}

resource "google_storage_bucket_iam_member" "sa_config_iam" {
  bucket = local.config_bucket_name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${local.cloudrun_service_account}"
}

resource "google_project_iam_member" "run_invoker" {
  count   = var.grant_run_invoker_permission ? 1 : 0
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${local.cloudrun_service_account}"
}