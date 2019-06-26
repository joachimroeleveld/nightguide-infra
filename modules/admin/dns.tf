resource "google_compute_global_address" "admin" {
  name = "admin"
}

resource "google_compute_managed_ssl_certificate" "admin" {
  provider = "google-beta"

  name = "admin"

  managed {
    domains = ["${var.dns_name}"]
  }
}

resource "google_dns_record_set" "admin" {
  name = "${var.dns_name}."
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${google_compute_global_address.admin.address}"]
}
