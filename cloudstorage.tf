

resource "google_storage_bucket" "twitter_data" {
  name     = "${var.name_prefix}-twitter-data"
  location = var.location
  project  = var.project


}