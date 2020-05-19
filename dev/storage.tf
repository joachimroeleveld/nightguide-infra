resource "google_storage_bucket" "ticket_codes" {
  name     = "ticket-codes.${var.dns_name}"
  location = "${var.bucket_location}"
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = "${google_storage_bucket.ticket_codes.name}"
  role        = "roles/storage.objectAdmin"
  member      = "user:joachim@nightguide.app"
}
