resource "google_service_account" "gcf_service_account" {
  account_id   = "cloudsql-export-tfmodule"
  display_name = var.function_name
}

resource "google_project_iam_custom_role" "gcf_custom_role" {
  role_id     = "allowCloudSQLExport"
  title       = "Custom Role For Cloud Function to Call CloudSQL Export"
  description = "Custom Role For Cloud Function to Call CloudSQL Export"
  permissions = ["cloudsql.instances.export"]
}

resource "google_project_iam_binding" "gcf_role_binding" {
  project = data.google_project.project.number
  role    = google_project_iam_custom_role.gcf_custom_role.name

  members = [
    "serviceAccount:${google_service_account.gcf_service_account.email}"
  ]
}