locals {
  create_config_bucket = var.config_file_bucket == ""
  config_bucket_name   = local.create_config_bucket ? resource.google_storage_bucket.config_bucket[0].name : var.config_file_bucket
}

resource "random_id" "suffix" {
  byte_length = 2
}

resource "google_storage_bucket" "config_bucket" {
  count                       = local.create_config_bucket ? 1 : 0
  project                     = var.project_id
  name                        = "${var.project_id}-cbgcnc-${random_id.suffix.hex}"
  uniform_bucket_level_access = true
  force_destroy               = true
  location                    = var.region
}

resource "random_id" "config_object_suffix" {
  byte_length = 2
}

resource "google_storage_bucket_object" "config" {
  name = "cloudbuild-googlechat-notifier-config-${random_id.config_object_suffix.hex}"
  content = templatefile("${path.module}/config.template", {
    filter     = var.build_filter
    secret_ref = var.webhook_secret_ref
  })
  bucket = local.config_bucket_name
}