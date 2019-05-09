resource "google_kms_key_ring" "scrapyd" {
  name     = "scrapyd"
  location = "global"
}

resource "google_kms_crypto_key" "scrapy_env" {
  name     = "scrapy_env"
  key_ring = "${google_kms_key_ring.scrapyd.id}"
}

data "google_kms_secret" "scrapy_env" {
  crypto_key = "${google_kms_crypto_key.scrapy_env.id}"
  ciphertext = "${base64encode(file("${path.module}/secrets/scrapy_env.${var.env}.enc"))}"
}
