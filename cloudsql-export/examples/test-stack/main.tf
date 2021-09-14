resource "random_id" "suffix" {
  byte_length = 4
}

module "mysql-db" {
  source               = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  name                 = local.instance_name
  random_instance_name = false
  database_version     = "MYSQL_8_0"
  project_id           = local.project_id
  zone                 = local.instance_zone
  region               = local.region
  tier                 = local.instance_tier

  deletion_protection = false

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = false
    authorized_networks = var.authorized_networks
  }


  database_flags = [
    {
      name  = "log_bin_trust_function_creators"
      value = "on"
    },
  ]

  create_timeout = "30m"
}

