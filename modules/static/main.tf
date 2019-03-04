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
  name = "${var.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${var.dns_data}"]
}

//module "gce-lb-https" {
//  source            = "../../"
//  name              = "static.nightguide.app"
//  url_map           = "${google_compute_url_map.static_https.self_link}"
//  ssl               = true
//  certificate       = "${tls_self_signed_cert.example.cert_pem}"
//}
//
//resource "google_compute_url_map" "static_https" {
//  name = "static"
//  default_service = "${google_compute_backend_bucket.static.name}"
//}
//
//resource "google_compute_backend_bucket" "static" {
//  name = "static"
//  bucket_name = "${google_storage_bucket.static.name}"
//  enable_cdn = true
//}

