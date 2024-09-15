resource "google_bigquery_dataset" "metering_dataset" {
  project       = local.project
  dataset_id    = "metering_gke"
  friendly_name = "metering_gke"
  description   = "GKE Resource Metering"
  location      = local.region
}
