resource "google_dns_record_set" "api" {
  name = "${var.dns_name}."
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${google_compute_global_address.api.address}"]
}

resource "google_compute_global_address" "api" {
  name = "api"
}

resource "google_compute_managed_ssl_certificate" "api" {
  provider = "google-beta"

  name = "api"

  managed {
    domains = ["${var.dns_name}"]
  }
}
