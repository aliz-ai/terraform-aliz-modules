locals {
  instance_prefix        = "hellomysql"
  instance_name          = "${local.instance_prefix}-${random_id.suffix.hex}"

  project_id             = "aip-aliz-prod-mp-20210920-2"
  region                 = "europe-west1"
  
  instance_tier          = "db-f1-micro"
  instance_zone          = "europe-west1-b"

  export_bucket_name     = "${local.instance_name}-export"
  export_bucket_location = local.region
  authorized_networks = [
  {
    name  = "starbak"
    value = "125.160.233.122/32"
  }
  ]
}