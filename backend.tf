terraform {
  required_version = ">= 0.14"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.30.0"
    }
  }
  backend "gcs" {
    bucket = "502629082044-tf-state-bucket"
    prefix = "terraform/state"
  }
}
