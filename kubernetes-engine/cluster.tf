locals {
  cluster_name_underscore = replace(var.cluster_name, "-", "_")
  metering_dataset_id     = "metering_${local.cluster_name_underscore}"
}

resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  location = var.region
  project  = var.project

  remove_default_node_pool = false
  initial_node_count       = 1

  logging_service           = "logging.googleapis.com/kubernetes"
  monitoring_service        = "monitoring.googleapis.com/kubernetes"
  default_max_pods_per_node = 30
  enable_shielded_nodes     = true

  release_channel {
    channel = "REGULAR"
  }

  network    = var.network
  subnetwork = var.subnetwork

  ip_allocation_policy {
    services_secondary_range_name = var.ip_range_services
    cluster_secondary_range_name  = var.ip_range_pods
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_range
  }

  database_encryption {
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.cluster-key.id
  }

  node_config {
    service_account = google_service_account.nodes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  cluster_autoscaling {
    enabled = true
    #autoscaling_profile = "OPTIMIZE_UTILIZATION"
    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = var.max_cpu
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 4
      maximum       = var.max_memory
    }
    resource_limits {
      resource_type = "nvidia-tesla-k80"
      maximum       = var.max_nvidia_k80
    }
    resource_limits {
      resource_type = "nvidia-tesla-v100"
      maximum       = var.max_nvidia_v100
    }
    resource_limits {
      resource_type = "nvidia-tesla-p100"
      maximum       = var.max_nvidia_p100
    }
    auto_provisioning_defaults {
      service_account = google_service_account.nodes.email
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
  }

  network_policy {
    provider = "CALICO"
    enabled  = true
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  resource_usage_export_config {
    enable_network_egress_metering = false

    bigquery_destination {
      dataset_id = var.metering_dataset_id
    }
  }
}

