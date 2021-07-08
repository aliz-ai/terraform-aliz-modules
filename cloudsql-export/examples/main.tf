module "main" {
  source = "../"

  cloud_scheduler_schedule = "0 7 * * *"

  database_name             = local.database_name
  cloudsql_instance_name    = local.cloudsql_instance_name
  backup_bucket             = local.backup_bucket
  cloud_scheduler_time_zone = local.cloud_scheduler_time_zone

  bucket_name     = local.bucket_name
  bucket_location = local.bucket_location

  topic_name = "hellomysql-export"

  function_bucket_name = local.function_bucket_name

  cloud_scheduler_name = local.cloud_scheduler_name

  region                 = local.bucket_location
  cloud_scheduler_region = "asia-southeast1"

  function_source_dir = "../scripts"

  project_id = local.project_id

}

