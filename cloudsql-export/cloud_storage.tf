resource "google_storage_bucket" "cloudsql_export" {
  name          = var.bucket_name
  location      = var.bucket_location
  force_destroy = var.bucket_force_destroy

  uniform_bucket_level_access = var.bucket_uniform_bucket_level_access

  labels = {
    name        = var.bucket_name
    environment = var.label_environment
  }
}
