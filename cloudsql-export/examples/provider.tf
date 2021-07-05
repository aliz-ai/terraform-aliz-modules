provider "google" {
  version = "~> 3.33"
  project = local.project_id
  region  = local.region
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_id" "name" {
  byte_length = 2
}