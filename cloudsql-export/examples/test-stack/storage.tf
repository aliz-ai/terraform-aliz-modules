resource "google_storage_bucket" "sql_export" {
  name          = local.export_bucket_name
  location      = local.export_bucket_location
  force_destroy = true

  uniform_bucket_level_access = true
  project                     = local.project_id
}
