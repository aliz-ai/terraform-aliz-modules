data "google_compute_default_service_account" "default" {
  project = var.project
}

resource "google_project_service" "required_api" {
  for_each = toset([
    "appengine.googleapis.com",
    "cloudscheduler.googleapis.com"
  ])
  project = var.project
  service = each.key
}

resource "google_cloudbuild_trigger" "tf-app-engine-clean-up-scheduled" {
  project = var.project
  name    = "tf-app-engine-clean-up-scheduled"

  github {
    owner = var.github_owner
    name  = var.github_name
    push {
      branch = var.branches_to_apply_regex
    }
  }
  disabled = true

  build {
    step {
      name       = "gcr.io/cloud-builders/gcloud"
      entrypoint = "bash"
      args = ["-c", <<EOT
        cloud config list project
        gcloud app services list >> services.txt
        tail -n +2 services.txt > services.txt.tmp && mv services.txt.tmp services.txt
        awk '{print $1}' services.txt > services.txt.tmp && mv services.txt.tmp services.txt
        filename=services.txt
        unset myArray
        declare -a myArray
        myArray=(`cat "$filename"`)
        for (( i = 0 ; i < ${#myArray[@]} ; i++))
        do
        echo "Service [$i]: ${myArray[$i]}"
        done
        for i in ${!myArray[@]}; do
        echo "Service : ${myArray[$i]}"
        gcloud app versions list --service=${myArray[$i]} --format="value(version.id)" --sort-by="~version.createTime" | tail -n +11 | xargs -r gcloud app versions delete --service=${myArray[$i]} --quiet
        done
        unset myArray
        rm services.txt
EOT
]
    }
  }
}

resource "google_cloud_scheduler_job" "tf-app-engine-cleanup-scheduler" {
  project     = var.project
  region      = var.region
  name        = "tf-app-engine-cleanup-scheduler"
  description = "Cloud Scheduler for App Engine version cleanup module"
  schedule    = "0 6 * * *"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = "https://cloudbuild.googleapis.com/v1/projects/${var.project}/triggers/${google_cloudbuild_trigger.tf-app-engine-clean-up-scheduled.trigger_id}:run"
    body        = "ewogICJicmFuY2hOYW1lIjogIm1hc3RlciIKfQ=="
    oauth_token {
      service_account_email = data.google_compute_default_service_account.default.email
    }
  }
}