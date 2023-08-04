resource "google_pubsub_topic" "cb_topic" {
  name    = "cloud-builds"
  project = var.project_id

  message_retention_duration = "86600s"
  depends_on                 = [google_project_service.services]
}