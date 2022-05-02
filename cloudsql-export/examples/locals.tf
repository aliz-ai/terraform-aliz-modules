locals {
  region = "europe-west1"

  cloud_scheduler_schedule = "0 7 * * *"

  cloudsql_database_names   = ["mysql"] # This is mysql (system) database
  cloudsql_instance_name    = "hellomysql-b3a64273"
  backup_bucket             = "hellomysql-b3a64273-export"
  cloud_scheduler_time_zone = "Etc/UTC"

  topic_name = "${local.cloudsql_instance_name}-topic"

  cloud_scheduler_name = "${local.cloudsql_instance_name}-scheduler"

  function_bucket_name     = "${local.cloudsql_instance_name}-function-bucket"
  function_bucket_location = local.region


  cloud_scheduler_region = local.region


  project_id                  = ""
  cloudsql_project_id         = local.project_id
  function_service_account_id = local.project_id
}
