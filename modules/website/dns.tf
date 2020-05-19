locals {
  dns_name = "${var.dns_domain}"
}

resource "google_compute_global_address" "website" {
  name = "website"
}

resource "google_compute_managed_ssl_certificate" "website" {
  provider = "google-beta"

  name = "website"

  managed {
    domains = ["${local.dns_name}"]
  }
}

resource "google_compute_managed_ssl_certificate" "website_www" {
  provider = "google-beta"

  name = "website-www"

  managed {
    domains = ["www.${local.dns_name}"]
  }
}

resource "google_dns_record_set" "website" {
  name = "${local.dns_name}."
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${google_compute_global_address.website.address}"]
}

resource "google_dns_record_set" "website_www" {
  name = "www.${local.dns_name}."
  type = "CNAME"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${local.dns_name}."]
}
