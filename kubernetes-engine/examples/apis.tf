
module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "13.0.0"

  project_id = local.project

  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "bigquery.googleapis.com",
    "secretmanager.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com"
  ]
}
