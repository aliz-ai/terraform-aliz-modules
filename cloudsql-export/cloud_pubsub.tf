resource "google_pubsub_topic" "cloudsql_export" {
  name = var.topic_name

  labels = {
    name        = var.topic_name
    environment = var.label_environment
  }
}
