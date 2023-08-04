resource "google_project_service" "services" {
  for_each = toset([
    "cloudbuild.googleapis.com",
    "pubsub.googleapis.com",
    "bigquery.googleapis.com",
  ])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}