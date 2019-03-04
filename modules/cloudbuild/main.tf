data "google_project" "infra" {
  project_id = "nightguide-infra"
}

resource "google_project_iam_binding" "cloudbuild_kms" {
  project = "${var.project}"
  role    = "roles/cloudkms.cryptoKeyDecrypter"

  members = ["serviceAccount:${data.google_project.infra.number}@cloudbuild.gserviceaccount.com"]
}

resource "google_project_iam_binding" "cloudbuild_editor" {
  project = "${var.project}"
  role    = "roles/editor"

  members = ["serviceAccount:${data.google_project.infra.number}@cloudbuild.gserviceaccount.com"]
}
