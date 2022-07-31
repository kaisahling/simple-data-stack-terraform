# cloud function
resource "google_service_account" "cloud_function_service_account" {
  project      = var.project
  account_id   = "cloud-function-sa"
  display_name = "Cloud function's service account"
}

resource "google_project_iam_member" "storage_admin_role_to_cloud_function_service_account" {
  project = var.project
  member  = "serviceAccount:${google_service_account.cloud_function_service_account.email}"
  role    = "roles/storage.admin"
}

# cloud function scheduler
resource "google_service_account" "cloud_function_scheduler_service_account" {
  account_id   = "cloud-function-scheduler-sa"
  project      = var.project
  display_name = "Cloud function scheduler's service account"
}

resource "google_project_iam_member" "cloudfunction_invoker_role_to_cloud_function_scheduler_service_account" {
  project = var.project
  member  = "serviceAccount:${google_service_account.cloud_function_scheduler_service_account.email}"
  role    = "roles/cloudfunctions.invoker"
}

# terraform build
resource "google_project_iam_member" "editor_to_compute_cloud_build_service_account" {
  role    = "roles/admin"
  project = var.project
  member  = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "secretmanager_to_compute_cloud_build_service_account" {
  role    = "roles/secretmanager.secretAccessor"
  project = var.project
  member  = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}

# dbt scheduler
resource "google_service_account" "dbt_scheduler_service_account" {
  account_id   = "dbt-scheduler-sa"
  project      = var.project
  display_name = "dbt scheduler scheduler service account"
}

resource "google_project_iam_member" "run_invoker_role_to_dbt_scheduler_service_account" {
  project = var.project
  member  = "serviceAccount:${google_service_account.dbt_scheduler_service_account.email}"
  role    = "roles/run.invoker"
}

# dbt service
resource "google_service_account" "dbt_service_account" {
  account_id   = "dbt-sa"
  project      = var.project
  display_name = "dbt service account"
}

resource "google_project_iam_member" "bigquery_job_user_role_to_dbt_service_account" {
  project = var.project
  member  = "serviceAccount:${google_service_account.dbt_service_account.email}"
  role    = "roles/bigquery.user"
} # Bigquery permissions according to https://docs.getdbt.com/reference/warehouse-profiles/bigquery-profile#required-permissions

resource "google_project_iam_member" "bigquery_data_editor_role_dbt_service_account" {
  project = var.project
  member  = "serviceAccount:${google_service_account.dbt_service_account.email}"
  role    = "roles/bigquery.dataEditor"
}

resource "google_project_iam_member" "storage_admin_role_to_dbt_service_account" {
  project = var.project
  member  = "serviceAccount:${google_service_account.dbt_service_account.email}"
  role    = "roles/storage.admin"
} # Storage access required for dbt: https://stackoverflow.com/questions/64276972/query-table-in-google-bigquery-has-error-access-denied-bigquery-bigquery-perm
