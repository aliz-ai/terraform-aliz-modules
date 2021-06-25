provider "google" {
  version = "~> 3.33"
  project = local.project_id
  region  = local.region
}