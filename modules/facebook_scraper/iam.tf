locals {
  iam_roles = ["roles/logging.logWriter"]
}

resource "google_service_account" "facebook_scraper" {
  account_id = "facebook-scraper"
}

resource "google_service_account_key" "facebook_scraper_sa" {
  service_account_id = "${google_service_account.facebook_scraper.email}"
  public_key_type = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "facebook_scraper" {
  count = "${length(local.iam_roles)}"
  role = "${local.iam_roles[count.index]}"
  member = "serviceAccount:${google_service_account.facebook_scraper.email}"
}
