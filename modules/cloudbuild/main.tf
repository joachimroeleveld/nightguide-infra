locals {
  builds_bucket = "builds.nightguide.app"
  cloudbuild_sa            = "${data.google_project.infra.number}@cloudbuild.gserviceaccount.com"
  helm_repository_location = "gs://${local.builds_bucket}/charts/${var.env}"
  helm_repository          = "${var.project}"
  cloudbuild_roles         = ["roles/cloudkms.cryptoKeyDecrypter", "roles/storage.admin"]
}

data "google_project" "infra" {
  project_id = "${var.infra_project}"
}

data "google_container_registry_repository" "builds" {
  project = "${var.project}"
}

resource "null_resource" "helm_repository" {
  provisioner "local-exec" {
    command = "helm gcs init ${local.helm_repository_location}"
  }
}

resource "google_project_iam_member" "cloudbuild_sa" {
  count  = "${length(local.cloudbuild_roles)}"
  role   = "${local.cloudbuild_roles[count.index]}"
  member = "serviceAccount:${local.cloudbuild_sa}"
}
