resource "google_pubsub_topic" "iam_change_log_topic" {
  project = var.project
  name    = "manual-iam-change-logs-topic"
}

resource "google_pubsub_topic_iam_member" "iam_change_log_topic_iam_member" {
  project = var.project
  role    = "roles/pubsub.publisher"
  member  = google_logging_organization_sink.iam_change_log_sink.writer_identity
  topic   = google_pubsub_topic.iam_change_log_topic.name
}

resource "google_logging_organization_sink" "iam_change_log_sink" {
  name        = "manual-iam-change-logs-sink"
  description = "Sink gathering logs of manual IAM changes"
  org_id      = var.org_id

  destination = "pubsub.googleapis.com/projects/${var.project}/topics/${google_pubsub_topic.iam_change_log_topic.name}"

  filter           = "resource.type=\"organization\" OR resource.type=\"folder\"\nproto_payload.method_name=\"SetIamPolicy\"\nproto_payload.authentication_info.principal_email!=\"${var.infra_service_account}\""
  include_children = true
}

resource "random_id" "id" {
  byte_length = 2
}

resource "google_storage_bucket" "function_source_bucket" {
  project  = var.project
  name     = "function-source-${random_id.id.hex}"
  location = var.region
}

data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = "${path.module}/notifier"
  output_path = "/tmp/notifier"
}

resource "google_storage_bucket_object" "cloud_function_archive" {
  name   = "notifier.zip"
  bucket = google_storage_bucket.function_source_bucket.name
  source = data.archive_file.function_source.output_path
}

resource "google_cloudfunctions_function" "iam_change_log_function" {
  project     = var.project
  region      = var.region
  name        = "iam-change-notifier-function"
  description = "Function to trigger when IAM changes occur"
  runtime     = "nodejs16"

  available_memory_mb   = 128
  max_instances         = 1
  source_archive_bucket = google_storage_bucket.function_source_bucket.name
  source_archive_object = google_storage_bucket_object.cloud_function_archive.name
  entry_point           = "pushEventsToWebhook"

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.iam_change_log_topic.name
  }

  secret_environment_variables {
    key        = "WEBHOOK_URL"
    project_id = var.project
    secret     = var.webhook_secret
    version    = 1
  }

  lifecycle {
    ignore_changes = [
      secret_environment_variables[0].project_id,
    ]
  }

  depends_on = [
    google_logging_organization_sink.iam_change_log_sink,
    google_storage_bucket_object.cloud_function_archive,
    google_pubsub_topic.iam_change_log_topic
  ]
}
/*
resource "google_cloudfunctions_function_iam_member" "iam_change_log_function_invoker" {
  project  = var.project
  role     = "roles/cloudfunctions.invoker"
  member   = "serviceAccount:${var.infra_service_account}"
  cloud_function = google_cloudfunctions_function.iam_change_log_function.name
}
*/
resource "google_secret_manager_secret_iam_member" "secret_accessor_member" {
  project   = var.project
  secret_id = var.webhook_secret
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.project}@appspot.gserviceaccount.com"
}
