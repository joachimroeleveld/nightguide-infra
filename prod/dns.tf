resource "google_dns_managed_zone" "main" {
  name     = "${replace(var.dns_name, ".", "-")}"
  dns_name = "${var.dns_name}."
}

resource "google_dns_record_set" "ns_google_domains" {
  name = "${google_dns_managed_zone.main.dns_name}"
  type = "NS"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.main.name}"

  rrdatas = [
    "ns-cloud-b1.googledomains.com.",
    "ns-cloud-b2.googledomains.com.",
    "ns-cloud-b3.googledomains.com.",
    "ns-cloud-b4.googledomains.com.",
  ]
}

resource "google_dns_record_set" "mx_gsuite" {
  name = "${google_dns_managed_zone.main.dns_name}"
  type = "MX"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.main.name}"

  rrdatas = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com.",
  ]
}

resource "google_dns_record_set" "spf" {
  name = "${google_dns_managed_zone.main.dns_name}"
  type = "TXT"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.main.name}"

  rrdatas = [
    "\"v=spf1 include:_spf.google.com include:transmail.net include:sendgrid.net ~all\"",
  ]
}

resource "google_dns_record_set" "dkim_zoho" {
  name = "1522905413783._domainkey.${google_dns_managed_zone.main.dns_name}"
  type = "TXT"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.main.name}"

  rrdatas = [
    "\"k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCr6KMgdxxgg7oT3ulMwPJs9RXgXDrI9UWU118pHEMohl3UbL3Jwp4oxp/9N3thh/3WCJnYV134zbEVolZwqaT3JsFEq/mQ/RpW/JnOZ3rnxqJPurb2bcfJol4SDxiWVObzHX31xnANzFcXnq1/5dMK5QvW4Jh7n0fm4+4ywqiy2QIDAQAB\"",
  ]
}

resource "google_dns_record_set" "dkim_sendgrid_1" {
  name = "s1._domainkey.${google_dns_managed_zone.main.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.main.name}"

  rrdatas = [
    "s1.domainkey.u8890242.wl243.sendgrid.net.",
  ]
}

resource "google_dns_record_set" "dkim_sendgrid_2" {
  name = "s2._domainkey.${google_dns_managed_zone.main.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.main.name}"

  rrdatas = [
    "s2.domainkey.u8890242.wl243.sendgrid.net.",
  ]
}

resource "google_dns_record_set" "zoho_domain_verification" {
  name = "em9646.${google_dns_managed_zone.main.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.main.name}"

  rrdatas = [
    "u8890242.wl243.sendgrid.net.",
  ]
}
