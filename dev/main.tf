provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

provider "google-beta" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${file("${path.module}/../deploy-key.json")}"
}

module "appengine" {
  source = "../modules/appengine"

  project = "${var.project}"
}

module "cloudbuild" {
  source = "../modules/cloudbuild"

  env             = "${var.env}"
  project         = "${var.project}"
  infra_project   = "${var.infra_project}"
  bucket_location = "${var.bucket_location}"
}

module "images" {
  source = "../modules/images"

  bucket_location = "${var.bucket_location}"
  bucket_name     = "images.${var.dns_name}"

  dns_name = "images.${var.dns_name}"

  dns_data = [
    "ghs.googlehosted.com.",
  ]

  dns_zone = "${google_dns_managed_zone.main.name}"
}
