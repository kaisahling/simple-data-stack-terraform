resource "google_cloudfunctions_function" "cloud_function" {
  name                = "tweets-cloud-functions"
  description         = "Import tweets from Twitter API"
  runtime             = "python39"
  project             = var.project
  available_memory_mb = 1024
  timeout             = 30
  trigger_http        = true
  max_instances       = 5
  entry_point         = "main"
  region              = var.location
  # invocation service account or ingress_settings = "ALLOW_INTERNAL_ONLY" setting,not both
  service_account_email = google_service_account.cloud_function_service_account.email
  # make sure that paths (currently src) is the same in here and in the corresponding cloud build trigger
  source_repository {
    url = "https://source.developers.google.com/projects/${var.project}/repos/${var.cloud_function_repo_name}/moveable-aliases/${local.branch}/paths/src"
  }

  environment_variables = {
    PROJECT_NUMBER = var.project_number
    STORAGE_BUCKET = google_storage_bucket.twitter_data.name
    BEARER_TOKEN   = var.twitter_api_token
    TWITTER_ID     = "44196397"
  }

  labels = merge(var.common_labels, {
    "pipeline-step" = "extract"
  })
}