locals {
  service_account_roles = concat([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])
}

resource "google_project_iam_member" "nodes_service_account_roles" {
  for_each = toset(local.service_account_roles)
  project  = var.project
  role     = each.value
  member   = "serviceAccount:${google_service_account.nodes.email}"
}

resource "google_service_account" "nodes" {
  project      = var.project
  account_id   = "gke-nodes-${var.cluster_name}"
  display_name = "Service Account for ${var.cluster_name} GKE nodes"
}

