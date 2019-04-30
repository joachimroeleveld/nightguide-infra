resource "google_dns_record_set" "website" {
  name = "${var.dns_name}."
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${var.dns_data}"]
}

resource "google_dns_record_set" "website_ipv6" {
  name = "${var.dns_name}."
  type = "AAAA"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${var.dns_data_ipv6}"]
}

resource "google_dns_record_set" "website_www" {
  name = "www.${var.dns_name}."
  type = "CNAME"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${var.dns_data_www}"]
}
