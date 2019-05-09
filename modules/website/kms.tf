resource "google_kms_key_ring" "website" {
  name     = "website"
  location = "global"
}

resource "google_kms_crypto_key" "ghost_chart_values" {
  name     = "ghost_chart_values"
  key_ring = "${google_kms_key_ring.website.id}"
}

data "google_kms_secret" "ghost_chart_values" {
  crypto_key = "${google_kms_crypto_key.ghost_chart_values.id}"
  ciphertext = "${base64encode(file("${path.module}/secrets/ghost_chart_values.${var.env}.enc"))}"
}
