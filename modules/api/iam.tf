locals {
  iam_roles = [
    "roles/cloudkms.cryptoKeyDecrypter",
    "roles/cloudtrace.agent"]
}

resource "google_service_account" "api" {
  account_id = "service-api"
}

resource "google_service_account_key" "api_sa" {
  service_account_id = "${google_service_account.api.email}"
  public_key_type = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "api" {
  count = "${length(local.iam_roles)}"
  role = "${local.iam_roles[count.index]}"
  member = "serviceAccount:${google_service_account.api.email}"
}

resource "google_storage_bucket_iam_member" "images_admin" {
  bucket = "${var.images_bucket}"
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.api.email}"
}

resource "google_storage_bucket_iam_member" "read_builds" {
  bucket = "${var.builds_bucket}"
  role = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.api.email}"
}

