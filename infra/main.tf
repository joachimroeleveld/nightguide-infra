provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

module "project" {
  source = "../modules/project"

  project = "${var.project}"
}
