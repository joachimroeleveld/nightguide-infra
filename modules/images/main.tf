resource "google_storage_bucket" "images" {
  name     = "${var.bucket_name}"
  location = "${var.bucket_location}"
}

resource "google_storage_bucket_iam_binding" "images_public" {
  bucket = "${google_storage_bucket.images.name}"
  role   = "roles/storage.objectViewer"

  members = ["allUsers", "allAuthenticatedUsers"]
}

resource "google_dns_record_set" "images" {
  name = "${var.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = "${var.dns_zone}"

  rrdatas = ["${var.dns_data}"]
}
