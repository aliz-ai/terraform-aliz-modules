resource "google_storage_bucket" "bucket" {
  project   = var.project_id
  name      = var.function_bucket_name
  location  = var.function_bucket_location
}

data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = "${path.module}/scripts"
  output_path = "/tmp/${var.function_archive_name}"
}

resource "google_storage_bucket_object" "cloud-function-archive" {
  name   = var.function_archive_name
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function_source.output_path 
}

resource "google_cloudfunctions_function" "cloud_build_stat" {
  project   = var.project_id
  name      = var.function_name
  runtime   = var.function_runtime

  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.cloud-function-archive.name
  entry_point           = "buildStat"

  build_environment_variables = {
    "USERNAME"  = var.bitbucket_username
    "PASSWORD"  = var.bitbucket_password
    "OWNER"     = var.bitbucket_owner
    "REPO"      = var.bitbucket_repo
  }

  event_trigger {
    event_type  = "google.pubsub.topic.publish"
    resource    = google_pubsub_topic.build-logs.id
    failure_policy {
      retry = false
    }
  }

  depends_on = [
    google_logging_project_sink.log-sink
  ]
}

resource "google_pubsub_topic" "build-logs" {
  project      = var.project_id
  name         = var.topic_name
}

resource "google_logging_project_sink" "log-sink" {
  project = var.project_id
  name        = var.logsink_name
  destination = "pubsub.googleapis.com/projects/${var.project_id}/topics/${google_pubsub_topic.build-logs.id}"
  filter      = "resource.type = \"build\" labels.build_step = \"MAIN\" textPayload : (\"starting build\" OR (\"DONE\" OR \"ERROR\")) labels.build_tags : \"trigger\""
}