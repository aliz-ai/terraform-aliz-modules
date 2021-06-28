
resource "google_cloud_scheduler_job" "main" {
  region      = var.cloud_scheduler_region
  name        = var.cloud_scheduler_name
  description = var.cloud_scheduler_description
  schedule    = var.cloud_scheduler_schedule

  pubsub_target {
    topic_name = google_pubsub_topic.cloudsql_export.id
    data       = base64encode("{\"dbs\":\"${var.database_name}\",\"instance\": \"${var.cloudsql_instance_name}\",\"project\":\"${var.project_id}\", \"gs\":\"${var.backup_bucket}\"}")
  }

  time_zone = var.cloud_scheduler_time_zone
}
