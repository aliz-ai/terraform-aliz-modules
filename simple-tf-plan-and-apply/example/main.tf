module "tf_pipeline" {
  source            = "../"
  project           = var.project
  github_owner      = "aliz-ai"
  github_name       = "terraform-aliz-modules"
  working_directory = "simple-tf-plan-and-apply/example/target"
}