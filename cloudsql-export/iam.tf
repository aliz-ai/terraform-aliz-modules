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
