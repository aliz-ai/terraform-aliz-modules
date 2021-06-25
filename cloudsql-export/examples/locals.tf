locals {
  cloud_scheduler_schedule = "0 7 * * *"
  cloudsql_service_name    = "hellomysql"

  database_name = "mysql" # This is mysql (system) database
  cloudsql_instance_name = "hellomysql-d7548fa2"
  backup_bucket = "gs://cloudsqlexport-lwkfn23flkf2f"
  cloud_schduler_time_zone = "Asia/Jakarta"

  bucket_name     = "hellomysql-export-bucket"
  bucket_location = "asia-southeast1"

  topic_name = "hellomysql-export"

  cloud_scheduler_name = "hellomysqlscheduler"

  function_bucket_name = "hellomysql-function-bucket"

  region = "asia-southeast1"

  cloud_scheduler_region = "asia-southeast1"
  project_id = "cloudsql-export-tfmodule"

  function_source_dir = "../scripts/"

}