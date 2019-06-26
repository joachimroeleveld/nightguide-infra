resource "google_kms_key_ring" "facebook_scraper" {
  name     = "facebook_scraper"
  location = "global"
}

resource "google_kms_crypto_key" "facebook_scraper_env" {
  name     = "facebook_scraper_env"
  key_ring = "${google_kms_key_ring.facebook_scraper.id}"
}

data "google_kms_secret" "facebook_scraper_env" {
  crypto_key = "${google_kms_crypto_key.facebook_scraper_env.id}"
  ciphertext = "${base64encode(file("${path.module}/secrets/facebook_scraper_env.${var.env}.enc"))}"
}
