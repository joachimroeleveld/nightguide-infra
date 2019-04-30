resource "google_compute_global_address" "scrapyd" {
  name = "scrapyd"
}

resource "google_dns_record_set" "scrapyd" {
  name = "${var.dns_name}."
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${google_compute_global_address.scrapyd.address}"]
}

resource "google_compute_managed_ssl_certificate" "scrapyd" {
  provider = "google-beta"

  name = "scrapyd"

  managed {
    domains = ["${var.dns_name}"]
  }
}
