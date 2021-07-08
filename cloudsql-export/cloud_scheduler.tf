locals {
  pubsub_data = {
    dbs: var.cloudsql_database_names,
    instance: var.cloudsql_instance_name
    project: var.cloudsql_project_id,
    gs: var.backup_bucket
  }
}

resource "google_cloud_scheduler_job" "main" {
  region      = var.cloud_scheduler_region
  name        = var.cloud_scheduler_name
  description = var.cloud_scheduler_description
  schedule    = var.cloud_scheduler_schedule

  pubsub_target {
    topic_name = google_pubsub_topic.cloudsql_export.id
    //    data       = base64encode("{\"dbs\":${cloud_sql_database_names_as_json},\"instance\": \"${var.cloudsql_instance_name}\",\"project\":\"${var.cloudsql_project_id}\", \"gs\":\"gs://${var.backup_bucket}\"}")
    data       = base64encode(jsonencode(local.pubsub_data))
  }

  time_zone = var.cloud_scheduler_time_zone
}
