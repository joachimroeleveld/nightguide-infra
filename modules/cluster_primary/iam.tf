# Needed for GCR pull access for GKE
resource "google_storage_bucket_iam_member" "member" {
  bucket = "eu.artifacts.${var.infra_project}.appspot.com"
  role        = "roles/storage.objectViewer"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}
