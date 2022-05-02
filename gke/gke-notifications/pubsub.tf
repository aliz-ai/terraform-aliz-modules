resource "google_pubsub_topic" "gke_notifications" {
  project = var.project_id
  name    = var.topic_name
}

output "gke_notification_pubsub_topic_id" {
  value = google_pubsub_topic.gke_notifications.id
}