resource "google_project_service" "project" {
  for_each = var.set_apis ? toset([
    "cloudscheduler.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "pubsub.googleapis.com"
  ]) : []
  project            = var.project
  service            = each.value
  disable_on_destroy = false
}

data "google_project" "default" {
  project_id = var.project
}