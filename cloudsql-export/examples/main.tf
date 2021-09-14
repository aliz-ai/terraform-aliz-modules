module "main" {
  source = "../"

  cloud_scheduler_schedule = local.cloud_scheduler_schedule

  cloudsql_database_names   = local.cloudsql_database_names
  cloudsql_instance_name    = local.cloudsql_instance_name
  backup_bucket             = local.backup_bucket
  cloud_scheduler_time_zone = local.cloud_scheduler_time_zone

  topic_name = local.topic_name

  function_bucket_name     = local.function_bucket_name
  function_bucket_location = local.function_bucket_location

  cloud_scheduler_name = local.cloud_scheduler_name

  cloud_scheduler_region = local.cloud_scheduler_region

  project_id                  = local.project_id
  function_service_account_id = local.function_service_account_id
  cloudsql_project_id         = local.project_id
}
