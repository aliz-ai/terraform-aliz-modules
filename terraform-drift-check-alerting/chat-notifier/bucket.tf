resource "random_id" "suffix" {
  byte_length = 2
}

resource "google_storage_bucket" "notifier_config_bucket" {
  location                    = "EU"
  project                     = var.project
  name                        = "notifier-config-tf-${random_id.suffix.hex}"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "notifier_config" {
  name    = "config.yaml"
  bucket  = google_storage_bucket.notifier_config_bucket.name
  content = <<-EOF
apiVersion: cloud-build-notifiers/v1
kind: GoogleChatNotifier
metadata:
  name: example-googlechat-notifier
spec:
  notification:
    filter: ${var.filter}
    delivery:
      webhookUrl:
        secretRef: webhook-url
  secrets:
  - name: webhook-url
    value: ${data.google_secret_manager_secret_version.webhook_url.name}
  EOF
  depends_on = [
    google_secret_manager_secret_version.webhook_url_version
  ]
}
