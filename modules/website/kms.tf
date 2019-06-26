resource "google_kms_key_ring" "website" {
  name     = "website"
  location = "global"
}

resource "google_kms_crypto_key" "website_env" {
  name     = "website_env"
  key_ring = "${google_kms_key_ring.website.id}"
}

data "google_kms_secret" "website_env" {
  crypto_key = "${google_kms_crypto_key.website_env.id}"
  ciphertext = "${base64encode(file("${path.module}/secrets/website_env.${var.env}.enc"))}"
}
