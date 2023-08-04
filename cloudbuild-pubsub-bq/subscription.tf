resource "google_bigquery_dataset_iam_member" "viewer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  role       = "roles/bigquery.metadataViewer"
  member     = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_bigquery_dataset_iam_member" "editor" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_pubsub_subscription" "bq_subscription" {
  project = var.project_id
  name    = "bq-subscription"
  topic   = google_pubsub_topic.cb_topic.name

  bigquery_config {
    table          = "${google_bigquery_table.cloudbuild_events.project}.${google_bigquery_table.cloudbuild_events.dataset_id}.${google_bigquery_table.cloudbuild_events.table_id}"
    write_metadata = true
  }

  depends_on = [google_bigquery_dataset_iam_member.viewer, google_bigquery_dataset_iam_member.editor, google_project_service.services]
}
