resource "google_kms_key_ring" "scrapyd" {
  name     = "scrapyd"
  location = "global"
}

resource "google_kms_crypto_key" "scrapy_env" {
  name     = "scrapy_env"
  key_ring = "${google_kms_key_ring.scrapyd.id}"
}

resource "google_kms_crypto_key" "spiderkeeper_admin_password" {
  name     = "spiderkeeper_admin_password"
  key_ring = "${google_kms_key_ring.scrapyd.id}"
}
