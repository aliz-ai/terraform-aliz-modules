module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "5.0.0"
  project_id   = local.project
  network_name = "example-vpc"
  routing_mode = "GLOBAL"
  subnets = [
    {
      subnet_name           = "cluster-1"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = local.region
      subnet_private_access = "true"
    }
  ]
  secondary_ranges = {
    cluster-1 = [
      {
        range_name    = "cluster-1-pods"
        ip_cidr_range = "10.11.0.0/16"
      },
      {
        range_name    = "cluster-1-services"
        ip_cidr_range = "10.12.0.0/18"
      },
    ]
  }
}

resource "google_compute_firewall" "rules" {
  project = local.project
  name    = "allow-ssh"
  network = module.vpc.network_name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_router" "router" {
  project = local.project
  name    = "nat-router"
  network = module.vpc.network_name
  region  = local.region
}

module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 2.2.0"
  project_id                         = local.project
  region                             = local.region
  router                             = google_compute_router.router.name
  name                               = "nat-config"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

