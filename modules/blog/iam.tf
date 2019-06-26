resource "google_service_account" "blog" {
  account_id = "service-blog"
}

resource "google_service_account_key" "blog_sa" {
  service_account_id = "${google_service_account.blog.email}"
  public_key_type = "TYPE_X509_PEM_FILE"
}

resource "google_storage_bucket_iam_member" "images_admin" {
  bucket = "${var.images_bucket}"
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.blog.email}"
}
