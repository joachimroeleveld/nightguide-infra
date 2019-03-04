resource "google_dns_record_set" "api" {
  name = "${var.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${var.dns_data}"]
}

resource "google_kms_key_ring" "api" {
  name     = "api"
  location = "${var.region}"
}

resource "google_kms_crypto_key" "api_secret_conf" {
  name     = "secret-conf"
  key_ring = "${google_kms_key_ring.api.id}"
}

resource "google_kms_key_ring_iam_binding" "api_deploy" {
  key_ring_id = "${google_kms_key_ring.api.id}"
  role        = "roles/viewer"

  members = ["serviceAccount:${google_service_account.api_deploy.email}"]
}

resource "google_service_account" "api_deploy" {
  account_id   = "api-deploy"
  display_name = "API deployment SA"
}

resource "google_project_iam_binding" "api_deploy" {
  role = "roles/editor"

  members = ["serviceAccount:${google_service_account.api_deploy.email}"]
}
