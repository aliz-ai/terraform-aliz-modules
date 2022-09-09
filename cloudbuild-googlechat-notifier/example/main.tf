resource "random_id" "suffix" {
  byte_length = 2
}

resource "google_project_service" "services" {
  for_each           = toset(["cloudbuild.googleapis.com", "run.googleapis.com"])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_cloudbuild_trigger" "trigger" {
  project = var.project_id
  name    = "trigger"
  github {
    owner = var.github_owner
    name  = var.github_repo
    push {
      branch = "^main$" // doesn't really matter
    }
  }
  build {
    step {
      name       = "busybox"
      entrypoint = "echo"
      args       = ["'x'"]
    }
  }
}

resource "google_pubsub_topic" "cloud_builds" {
  name    = "cloud-builds"
  project = var.project_id
}

module "notification" {
  source             = "../"
  project_id         = var.project_id
  region             = var.region
  build_filter       = "build.build_trigger_id == '${google_cloudbuild_trigger.trigger.trigger_id}'"
  webhook_secret_ref = var.webhook_secret_ref
}