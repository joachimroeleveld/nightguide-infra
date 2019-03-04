resource "google_dns_managed_zone" "main" {
  name     = "${replace(var.dns_name, ".", "-")}"
  dns_name = "${var.dns_name}."
}

resource "google_dns_record_set" "ns" {
  project = "${var.prod_project}"
  name    = "${google_dns_managed_zone.main.dns_name}"
  type    = "NS"
  ttl     = 300

  managed_zone = "${var.prod_managed_zone}"

  rrdatas = ["${google_dns_managed_zone.main.name_servers}"]
}
