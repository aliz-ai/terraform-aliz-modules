resource "google_storage_bucket" "sql_export" {
  name          = "cloudsqlexport-lwkfn23flkf2f"
  location      = "ASIA-SOUTHEAST1"
  force_destroy = true

  uniform_bucket_level_access = true
  project = local.project_id
}

resource "google_project_iam_custom_role" "rw_cloudsql_export_bucket" {
  role_id     = "ReadWriteCloudSQLExportBucket"
  title       = "Allow Read Write to CloudSQL Export Bucket"
  description = "Allow Read Write to CloudSQL Export Bucket"
  permissions = [
    "storage.objects.create",
    "storage.objects.get"
  ]
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = google_storage_bucket.sql_export.name
  role = google_project_iam_custom_role.rw_cloudsql_export_bucket.name
  members = [
      "user:sumodirjo@gmail.com",
      "serviceAccount:${module.mysql-db.instance_service_account_email_address}",
  ]
}