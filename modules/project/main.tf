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

output "project_number" {
  value = "${google_project.project.number}"
}
