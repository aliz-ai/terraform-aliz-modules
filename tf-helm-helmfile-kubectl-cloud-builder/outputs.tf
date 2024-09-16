output "google_artifact_repo_name" {
  value = google_artifact_registry_repository.tf-image-repo.name
}

output "builder_image" {
  value = "${var.default_region}-docker.pkg.dev/${google_artifact_registry_repository.tf-image-repo.project}/${google_artifact_registry_repository.tf-image-repo.name}/${var.builder_image_name}:latest"
}