# cloud function
resource "google_cloud_scheduler_job" "cloud_function_scheduler" {
  name             = "cloud_function_scheduler"
  description      = "Tuns the cloud function"
  schedule         = "0 1 * * *"
  time_zone        = "Europe/Berlin"
  region           = var.location
  attempt_deadline = "30s"
  project          = var.project

  retry_config {
    retry_count = 0
  }

  http_target {
    http_method = "GET"
    uri         = "https://${var.location}-${var.project}.cloudfunctions.net/${google_cloudfunctions_function.cloud_function.name}"
    headers = {
      Content-Type = "application/json"
    }
    # see here how body must look like
    # https://www.reddit.com/r/googlecloud/comments/lrv9eo/cant_pass_any_arguments_to_a_workflow_when_using/
    oidc_token {
      service_account_email = google_service_account.cloud_function_scheduler_service_account.email
    }
  }
}

# dbt
resource "google_cloud_scheduler_job" "dbt_scheduler" {
  name             = "dbt_scheduler"
  description      = "Triggers dbt service"
  schedule         = "45 * * * *"
  time_zone        = "Europe/Berlin"
  region           = var.location
  attempt_deadline = "1800s"
  project          = var.project

  retry_config {
    retry_count = 0
  }

  http_target {
    http_method = "GET"
    uri         = "https://simple-data-stack-dbt-service-supsq3gcba-ey.a.run.app"
    headers = {
      Content-Type = "application/json"
    }
    # see here how body must look like
    # https://www.reddit.com/r/googlecloud/comments/lrv9eo/cant_pass_any_arguments_to_a_workflow_when_using/
    oidc_token {
      service_account_email = google_service_account.dbt_scheduler_service_account.email
    }
  }
}
