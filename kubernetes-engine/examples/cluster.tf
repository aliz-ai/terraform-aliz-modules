
module "cluster-1" {
  source              = "../"
  cluster_name        = "cluster-1"
  region              = local.region
  project             = local.project
  network             = module.vpc.network_name
  subnetwork          = module.vpc.subnets_names[0]
  ip_range_pods       = "cluster-1-pods"
  ip_range_services   = "cluster-1-services"
  master_range        = "10.254.0.0/28"
  metering_dataset_id = "metering_gke"
  depends_on = [
    module.project-services
  ]
}
