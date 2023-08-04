resource "google_bigquery_dataset" "dataset" {
  project       = var.project_id
  dataset_id    = "cloudbuild_events"
  friendly_name = "CloudBuild Events"
  location      = var.bigquery_location

  depends_on = [google_project_service.services]
}

resource "google_bigquery_table" "cloudbuild_events" {
  project             = var.project_id
  table_id            = "cloudbuild_events"
  dataset_id          = google_bigquery_dataset.dataset.dataset_id
  deletion_protection = false

  schema = <<EOF
[
    {
        "name": "data",
        "type": "JSON",
        "mode": "NULLABLE"
    },
    {
        "name": "publish_time",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    },
    {
        "name": "subscription_name",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "message_id",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "attributes",
        "type": "JSON",
        "mode": "NULLABLE"
    }
]
EOF
}