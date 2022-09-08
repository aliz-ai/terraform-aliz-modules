data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_iam_member" "pubsub_sa_tc" {
  count   = var.grant_pubsub_sa_permission ? 1 : 0
  project = var.project_id
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
  role    = "roles/iam.serviceAccountTokenCreator"
}

resource "google_pubsub_subscription" "subs" {
  project = var.project_id
  name    = "build-trigger-subs-${random_id.suffix.hex}"
  topic   = "cloud-builds"

  push_config {
    push_endpoint = google_cloud_run_service.default.status[0].url
    oidc_token {
      service_account_email = local.cloudrun_service_account
    }
  }
}