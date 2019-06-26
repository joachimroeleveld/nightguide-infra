resource "google_kms_key_ring" "blog" {
  name     = "blog"
  location = "global"
}

resource "google_kms_crypto_key" "blog_chart_values" {
  name     = "blog_chart_values"
  key_ring = "${google_kms_key_ring.blog.id}"
}

data "google_kms_secret" "blog_chart_values" {
  crypto_key = "${google_kms_crypto_key.blog_chart_values.id}"
  ciphertext = "${base64encode(file("${path.module}/secrets/blog_chart_values.${var.env}.enc"))}"
}
