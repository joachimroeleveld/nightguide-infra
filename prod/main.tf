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

  project_number = "${module.project.project_number}"
  project = "${var.project}"
}

module "cloudbuild" {
  source = "../modules/cloudbuild"

  project = "${var.project}"
}

module "website" {
  source = "../modules/website"

  dns_zone = "${google_dns_managed_zone.main.name}"
  dns_name = "${google_dns_managed_zone.main.dns_name}"

  dns_data = [
    "216.239.32.21",
    "216.239.34.21",
    "216.239.36.21",
    "216.239.38.21",
  ]

  dns_data_ipv6 = [
    "2001:4860:4802:32::15",
    "2001:4860:4802:34::15",
    "2001:4860:4802:36::15",
    "2001:4860:4802:38::15",
  ]

  dns_data_www = [
    "ghs.googlehosted.com.",
  ]
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

module "static" {
  source = "../modules/static"

  bucket_location = "${var.bucket_location}"
  bucket_name     = "static.${var.dns_name}"

  dns_name = "static.${google_dns_managed_zone.main.dns_name}"

  dns_data = [
    "35.244.195.251",
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
