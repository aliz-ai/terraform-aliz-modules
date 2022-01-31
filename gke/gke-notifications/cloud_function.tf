resource "google_storage_bucket" "function_bucket" {
  project                     = var.project_id
  name                        = var.function_bucket_name
  location                    = var.function_bucket_location
  uniform_bucket_level_access = true
}

data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = "${path.module}/scripts"
  output_path = "/tmp/${var.function_archive_name}"
}

resource "google_storage_bucket_object" "function_archive" {
  name   = var.function_archive_name
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.function_source.output_path
}

resource "google_cloudfunctions_function" "main" {
  project     = var.project_id
  name        = var.function_name
  description = var.function_description
  runtime     = "nodejs10"
  region      = var.function_region

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_archive.name
  entry_point           = "notifier"
#  service_account_email = google_service_account.function_service_account.email

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.gke_notifications.id
    failure_policy {
      retry = false
    }
  }

  environment_variables = {
    GOOGLE_CHAT_WEBHOOK_URL = var.google_chat_webhook_url
  }

}