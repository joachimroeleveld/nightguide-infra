resource "google_compute_global_address" "blog" {
  name = "blog"
}

resource "google_compute_managed_ssl_certificate" "blog" {
  provider = "google-beta"

  name = "blog"

  managed {
    domains = ["${var.dns_name}"]
  }
}

resource "google_dns_record_set" "blog" {
  name = "${var.dns_name}."
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${google_compute_global_address.blog.address}"]
}
