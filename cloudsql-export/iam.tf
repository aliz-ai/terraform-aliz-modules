resource "google_service_account" "function_service_account" {
  project      = var.project_id
  account_id   = var.function_service_account_id
  display_name = var.function_service_account_name
}

resource "google_project_iam_member" "gcf_role_binding" {
  project = var.cloudsql_project_id
  role    = "roles/cloudsql.editor"
  member  = "serviceAccount:${google_service_account.function_service_account.email}"
}

data "google_sql_database_instance" "sql_database_instance" {
  project = var.cloudsql_project_id
  name    = var.cloudsql_instance_name
}

resource "google_storage_bucket_iam_member" "backup_bucket_member" {
  bucket = var.backup_bucket
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${data.google_sql_database_instance.sql_database_instance.service_account_email_address}"
}