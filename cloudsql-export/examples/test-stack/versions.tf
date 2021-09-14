terraform {
  required_version = ">=1.0.0"
  required_providers {
    google = {
      version = "~> 3.22"
    }

    null = {
      version = "> 2.1"
    }

    random = {
      version = "> 2.2"
    }
  }
}


provider "google" {
  project = local.project_id
  region  = local.region
}