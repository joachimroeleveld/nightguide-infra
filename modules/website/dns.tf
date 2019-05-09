resource "google_compute_global_address" "website" {
  name = "website"
}

resource "google_compute_managed_ssl_certificate" "website" {
  provider = "google-beta"

  name = "website"

  managed {
    domains = ["${var.dns_name}"]
  }
}

resource "google_dns_record_set" "website" {
  name = "${var.dns_name}."
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${google_compute_global_address.website.address}"]
}

resource "google_dns_record_set" "website_www" {
  name = "www.${var.dns_name}."
  type = "CNAME"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${google_dns_record_set.website.name}"]
}
