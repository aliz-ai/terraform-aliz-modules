resource "google_service_account" "function_service_account" {
  account_id   = var.project_id
  display_name = var.function_service_account_name
}

resource "google_project_iam_custom_role" "main" {
  project     = var.cloudsql_project_id
  role_id     = var.function_role_id
  title       = var.function_role_title
  description = var.function_role_description
  permissions = [
    "cloudsql.instances.export"
  ]
}

resource "google_project_iam_binding" "gcf_role_binding" {
  project = var.cloudsql_project_id
  role    = google_project_iam_custom_role.main.name

  members = [
    "serviceAccount:${google_service_account.function_service_account.email}"
  ]
}