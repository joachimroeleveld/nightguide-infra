resource "google_storage_bucket" "ticket_codes" {
  name     = "ticket-codes.${var.dns_domain}"
  location = "${var.bucket_location}"
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = "${google_storage_bucket.ticket_codes.name}"
  role        = "roles/storage.objectAdmin"
  member      = "serviceAccount:${google_service_account.api.email}"
}
