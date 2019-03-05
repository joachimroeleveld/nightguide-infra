provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

module "project" {
  source = "../modules/project"

  project = "${var.project}"
}

module "appengine" {
  source = "../modules/appengine"

  project = "${var.project}"
  project_number = "${module.project.project_number}"
}

module "cloudbuild" {
  source = "../modules/cloudbuild"

  project = "${var.project}"
}

module "api" {
  source = "../modules/api"

  project = "${var.project}"
  region  = "${var.region}"

  dns_name = "api.${google_dns_managed_zone.main.dns_name}"

  dns_data = [
    "ghs.googlehosted.com.",
  ]

  dns_zone = "${google_dns_managed_zone.main.name}"
}

module "images" {
  source = "../modules/images"

  bucket_location = "${var.bucket_location}"
  bucket_name     = "images.${var.dns_name}"

  dns_name = "images.${google_dns_managed_zone.main.dns_name}"

  dns_data = [
    "ghs.googlehosted.com.",
  ]

  dns_zone = "${google_dns_managed_zone.main.name}"
}
