resource "google_compute_global_address" "static" {
  name = "static"
}

resource "google_storage_bucket" "static" {
  name     = "${var.bucket_name}"
  location = "${var.bucket_location}"
}

resource "google_storage_bucket_iam_binding" "static_public" {
  bucket = "${google_storage_bucket.static.name}"
  role   = "roles/storage.objectViewer"

  members = ["allUsers", "allAuthenticatedUsers"]
}

resource "google_dns_record_set" "static" {
  name = "${var.dns_name}."
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${google_compute_global_address.static.address}"]
}

resource "google_compute_url_map" "static" {
  name            = "static"
  default_service = "${google_compute_backend_bucket.static.self_link}"

  host_rule = {
    hosts        = ["${var.dns_name}"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_bucket.static.self_link}"
  }
}

resource "google_compute_target_https_proxy" "static" {
  name             = "static-https"
  url_map          = "${google_compute_url_map.static.self_link}"
  ssl_certificates = ["${google_compute_managed_ssl_certificate.static.self_link}"]
}

resource "google_compute_global_forwarding_rule" "static" {
  name       = "static"
  target     = "${google_compute_target_https_proxy.static.self_link}"
  ip_address = "${google_compute_global_address.static.address}"
  port_range = 443
}

resource "google_compute_backend_bucket" "static" {
  name        = "static"
  bucket_name = "${google_storage_bucket.static.name}"
  enable_cdn  = true
}

resource "google_compute_managed_ssl_certificate" "static" {
  provider = "google-beta"

  name = "static"

  managed {
    domains = ["${var.dns_name}"]
  }
}
