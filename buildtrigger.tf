locals {
  branch = "main"
}
resource "google_cloudbuild_trigger" "cloud_function_build_trigger" {
  project = var.project

  trigger_template {
    branch_name = local.branch
    repo_name   = var.cloud_function_repo_name
  }

  substitutions = {
    _REPOSITORY_NAME = var.cloud_function_repo_name
    _BRANCH_NAME     = local.branch
    #must be same branch as in trigger template
    _PATH                = "src"
    _LOCATION            = var.location
    _CLOUD_FUNCTION_NAME = google_cloudfunctions_function.cloud_function.name
    _PYTHON_VERSION      = google_cloudfunctions_function.cloud_function.runtime
  }

  filename = "cloudbuild.yaml"
  name     = "cloud-function-build-trigger"

}

resource "google_cloudbuild_trigger" "infrastructure_build_trigger" {
  project = var.project

  trigger_template {
    branch_name = local.branch
    repo_name   = "github_kaisahling_simple-data-stack-terraform"
  }

  filename = "cloudbuild.yaml"
  name     = "terraform-build-trigger"


}
