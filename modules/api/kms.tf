resource "google_kms_key_ring" "api" {
  name     = "api"
  location = "global"
}

resource "google_kms_crypto_key" "env" {
  name     = "env"
  key_ring = "${google_kms_key_ring.api.id}"
}

resource "google_kms_crypto_key_iam_member" "cloudbuild_env" {
  crypto_key_id = "${google_kms_crypto_key.env.self_link}"
  role          = "roles/viewer"
  member = "serviceAccount:${var.cloudbuild_sa}"
}
