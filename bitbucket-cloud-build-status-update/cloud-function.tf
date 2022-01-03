resource "random_id" "id" {
  byte_length = 8
}

resource "google_storage_bucket" "function_source_bucket" {
  project  = var.project_id
  name     = "function-source-${random_id.id.hex}"
  location = var.region
}

data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = "${path.module}/scripts"
  output_path = "/tmp/${var.function_archive_name}"
}

resource "google_storage_bucket_object" "cloud_function_archive" {
  name   = var.function_archive_name
  bucket = google_storage_bucket.function_source_bucket.name
  source = data.archive_file.function_source.output_path
}

resource "google_cloudfunctions_function" "cloud_build_stat" {
  project     = var.project_id
  region      = var.region
  name        = "${var.function_name}-${random_id.id.hex}"
  runtime     = var.function_runtime
  description = var.function_description

  available_memory_mb   = var.function_memory_mb
  source_archive_bucket = google_storage_bucket.function_source_bucket.name
  source_archive_object = google_storage_bucket_object.cloud_function_archive.name
  entry_point           = "buildStat"

  environment_variables = {
    "KEY_ID"    = var.bitbucket_key_resource_id
    "SECRET_ID" = var.bitbucket_secret_resource_id
    "OWNER"     = var.bitbucket_owner
    "REPO"      = var.bitbucket_repo
  }

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.build_logs.id
    failure_policy {
      retry = false
    }
  }

  depends_on = [
    google_logging_project_sink.log_sink
  ]
}

resource "google_pubsub_topic" "build_logs" {
  project = var.project_id
  name    = var.topic_name
}

resource "google_logging_project_sink" "log_sink" {
  project     = var.project_id
  name        = var.logsink_name
  destination = "pubsub.googleapis.com/projects/${var.project_id}/topics/${google_pubsub_topic.build_logs.name}"
  filter      = "resource.type = \"build\" labels.build_step = \"MAIN\" textPayload : (\"starting build\" OR (\"DONE\" OR \"ERROR\")) labels.build_tags : \"trigger\""

  unique_writer_identity = true
}

resource "google_project_iam_binding" "log_writer" {
  project = var.project_id
  role    = "roles/pubsub.publisher"

  members = [
    google_logging_project_sink.log_sink.writer_identity,
  ]
}

resource "google_secret_manager_secret_iam_binding" "secret_binding" {
  project   = split("/", var.bitbucket_secret_resource_id)[1]
  secret_id = split("/", var.bitbucket_secret_resource_id)[3]
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",
  ]
}

resource "google_secret_manager_secret_iam_binding" "key_binding" {
  project   = split("/", var.bitbucket_key_resource_id)[1]
  secret_id = split("/", var.bitbucket_key_resource_id)[3]
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",
  ]
}