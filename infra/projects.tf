data "google_organization" "nightguide" {
  domain = "nightguide.app"
}

data "google_billing_account" "account" {
  display_name = "Default billing account"
  open         = true
}

resource "google_project" "project" {
  name       = "${var.project}"
  project_id = "${var.project}"
  org_id     = "${data.google_organization.nightguide.id}"

  billing_account = "${data.google_billing_account.account.id}"
}

resource "google_project" "app_dev" {
  name       = "${var.project_app_dev}"
  project_id = "${var.project_app_dev}"
  org_id     = "${data.google_organization.nightguide.id}"

  billing_account = "${data.google_billing_account.account.id}"
}

resource "google_project" "app_prod" {
  name       = "${var.project_app_prod}"
  project_id = "${var.project_app_prod}"
  org_id     = "${data.google_organization.nightguide.id}"

  billing_account = "${data.google_billing_account.account.id}"
}
