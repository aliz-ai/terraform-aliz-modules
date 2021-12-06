variable "cloudbuild_project_id" {
  description = "The project id where the pipelines and repos should be created"
  type        = string
}

variable "default_region" {
  description = "Default region to create resources where applicable."
  type        = string
}

variable "builder_image_name" {
  description = "Name of the builder image"
  type        = string
  default = "tf-helm-helmfile-kubectl-image"
}

variable "terraform_version" {
  description = "Default terraform version."
  type        = string
  default     = "1.0.11"
}

variable "terraform_version_sha256sum" {
  description = "sha256sum for default terraform version."
  type        = string
  default     = "eeb46091a42dc303c3a3c300640c7774ab25cbee5083dafa5fd83b54c8aca664"
}

variable "terraform_validator_release" {
  description = "Default terraform-validator release."
  type        = string
  default     = "v0.4.0"
}

variable "helm_version" {
  description = "Default helm version."
  type        = string
  default     = "v3.7.0"
}

variable "helm_sha256" {
  description = "sha256 for default helm version."
  type        = string
  default     = "096e30f54c3ccdabe30a8093f8e128dba76bb67af697b85db6ed0453a2701bf9"
}

variable "helmfile_version" {
  description = "Default helmfile version."
  type        = string
  default     = "v0.142.0"
}

variable "kubectl_version" {
  description = "Default kube version."
  type        = string
  default     = "v1.22.4"
}

variable "google_provider_version" {
  description = "Version of the google provider"
  type        = string
  default     = "4.1"
}

variable "google_beta_provider_version" {
  description = "Version of the google-beta provider"
  type        = string
  default     = "4.1"
}