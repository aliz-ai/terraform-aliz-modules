data "google_project" "cloudbuild_project" {
  project_id = var.cloudbuild_project_id
}
resource "google_artifact_registry_repository" "tf-image-repo" {
  provider = google-beta
  project  = var.cloudbuild_project_id

  location      = var.default_region
  repository_id = "tf-helm-helmfile-kubectl-image-build-repo"
  description   = "Docker repository for Terraform runner images used by Cloud Build"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "member" {
  provider  = google-beta
  project   = google_artifact_registry_repository.tf-image-repo.project
  location  = google_artifact_registry_repository.tf-image-repo.location
  repository = google_artifact_registry_repository.tf-image-repo.repository_id
  role       = "roles/artifactregistry.writer"
  member = "serviceAccount:${data.google_project.cloudbuild_project.number}@cloudbuild.gserviceaccount.com"
}

resource "null_resource" "cloudbuild_terraform_builder" {
  triggers = {
    project_id_cloudbuild_project = var.cloudbuild_project_id
    terraform_version_sha256sum   = var.terraform_version_sha256sum
    terraform_version             = var.terraform_version
    helm_sha256                   = var.helm_sha256
    helm_version                  = var.helm_version
    helmfile_version              = var.helmfile_version
    kubectl_version                  = var.kubectl_version
    gar_location                  = google_artifact_registry_repository.tf-image-repo.location
  }

  provisioner "local-exec" {
    command = <<EOT
      gcloud builds submit ${path.module}/ \
      --project ${var.cloudbuild_project_id} \
      --config=${path.module}/cloudbuild.yaml \
      --substitutions=_TERRAFORM_VERSION=${var.terraform_version},_TERRAFORM_VERSION_SHA256SUM=${var.terraform_version_sha256sum},_TERRAFORM_VALIDATOR_RELEASE=${var.terraform_validator_release},_HELM_VERSION=${var.helm_version},_HELM_SHA256=${var.helm_sha256},_HELMFILE_VERSION=${var.helmfile_version},_KUBECTL_VERSION=${var.kubectl_version},_REGION=${google_artifact_registry_repository.tf-image-repo.location},_REPOSITORY=${google_artifact_registry_repository.tf-image-repo.name},_BUILDER_IMAGE_NAME=${var.builder_image_name},_GOOGLE_PROVIDER_VERSION=${var.google_provider_version},_GOOGLE_BETA_PROVIDER_VERSION=${var.google_beta_provider_version}\
  EOT
  }

  depends_on = [
    google_artifact_registry_repository_iam_member.member
  ]
}