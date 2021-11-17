resource "random_id" "id" {
  byte_length = 8
}

resource "google_storage_bucket" "function_source_bucket" {
  project  = var.project_id
  name     = "function-source-${random_id.id.hex}"
  location = var.project_location
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
  region      = var.project_location
  name        = "${var.function_name}-${random_id.id.hex}"
  runtime     = var.function_runtime
  description = var.function_description

  available_memory_mb   = var.function_memory_mb
  source_archive_bucket = google_storage_bucket.function_source_bucket.name
  source_archive_object = google_storage_bucket_object.cloud_function_archive.name
  entry_point           = "buildStat"

  environment_variables = {
    "KEY_ID"    = data.google_secret_manager_secret_version.bitbucket_key.id
    "SECRET_ID" = data.google_secret_manager_secret_version.bitbucket_secret.id
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

data "google_secret_manager_secret_version" "bitbucket_secret" {
  secret  = var.bitbucket_secret_id
  project = var.bitbucket_secret_project_id
  version = var.bitbucket_secret_version
}

resource "google_secret_manager_secret_iam_binding" "secret_binding" {
  project   = data.google_secret_manager_secret_version.bitbucket_secret.project
  secret_id = var.bitbucket_secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",
  ]
}

data "google_secret_manager_secret_version" "bitbucket_key" {
  secret  = var.bitbucket_key_id
  project = var.bitbucket_key_project_id
  version = var.bitbucket_key_version
}

resource "google_secret_manager_secret_iam_binding" "key_binding" {
  project   = data.google_secret_manager_secret_version.bitbucket_key.project
  secret_id = var.bitbucket_key_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",
  ]
}