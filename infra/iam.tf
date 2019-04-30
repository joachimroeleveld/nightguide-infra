locals {
  deploy_admin_roles = ["roles/owner", "roles/storage.admin", "roles/resourcemanager.projectIamAdmin"]
}

resource "google_service_account" "joachim_deploy" {
  account_id   = "joachim-deploy"
  display_name = "Joachim deployment SA"
}

# TODO: create role to be able to assign to multiple members

resource "google_project_iam_member" "deploy_admins_infra" {
  count  = "${length(local.deploy_admin_roles)}"
  role   = "${local.deploy_admin_roles[count.index]}"
  member = "serviceAccount:${google_service_account.joachim_deploy.email}"
}

resource "google_project_iam_member" "deploy_admins_prod" {
  project = "${var.project_app_prod}"
  count   = "${length(local.deploy_admin_roles)}"
  role    = "${local.deploy_admin_roles[count.index]}"
  member  = "serviceAccount:${google_service_account.joachim_deploy.email}"
}

resource "google_project_iam_member" "deploy_admins_dev" {
  project = "${var.project_app_dev}"
  count   = "${length(local.deploy_admin_roles)}"
  role    = "${local.deploy_admin_roles[count.index]}"
  member  = "serviceAccount:${google_service_account.joachim_deploy.email}"
}
