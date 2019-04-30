data "google_project" "project" {
  project_id = "${var.project}"
}

data "google_client_config" "deploy" {
  provider = "google"
}

module "appengine" {
  source = "../modules/appengine"

  project = "${var.project}"
}

module "cloudbuild" {
  source = "../modules/cloudbuild"

  env = "${var.env}"
  project = "${var.project}"
  infra_project = "${var.infra_project}"
  bucket_location = "${var.bucket_location}"
}

module "cluster_primary" {
  source = "../modules/cluster_primary"

  infra_project = "${var.infra_project}"
  region = "${var.region}"
  zones = [
    "${var.zone}"]

  machine_type = "custom-2-3072" // 2vCPU + 3GB RAM
}

module "website" {
  source = "../modules/website"

  dns_zone = "${google_dns_managed_zone.main.name}"
  dns_name = "${var.dns_name}"

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
  cloudbuild_sa = "${module.cloudbuild.cloudbuild_sa}"
  infra_project = "${var.infra_project}"

  env = "${var.env}"
  app_version = "${var.api_version}"
  builds_bucket = "${module.cloudbuild.builds_bucket}"
  image_repository = "${module.cloudbuild.image_repository}"
  helm_repository = "${module.cloudbuild.helm_repository}"

  replica_count = 2
  cpu_limit = "0.5"
  cpu_request = "0.1"
  memory_limit = "500M"
  memory_request = "150M"

  dns_name = "api.${var.dns_name}"
  dns_zone = "${google_dns_managed_zone.main.name}"
}

module "scrapyd" {
  source = "../modules/scrapyd"

  project = "${var.project}"
  env = "${var.env}"

  app_version      = "${var.scrapyd_version}"
  image_repository = "${module.cloudbuild.image_repository}"
  helm_repository  = "${module.cloudbuild.helm_repository}"

  dns_name = "spiders.${var.dns_name}"
  dns_zone = "${google_dns_managed_zone.main.name}"
}

module "static" {
  source = "../modules/static"

  bucket_location = "${var.bucket_location}"
  bucket_name = "static.${var.dns_name}"

  dns_name = "static.${var.dns_name}"
  dns_data = [
    "35.244.195.251",
  ]
  dns_zone = "${google_dns_managed_zone.main.name}"
}

module "images" {
  source = "../modules/images"

  bucket_location = "${var.bucket_location}"
  bucket_name = "images.${var.dns_name}"

  dns_name = "images.${var.dns_name}"
  dns_data = [
    "ghs.googlehosted.com.",
  ]
  dns_zone = "${google_dns_managed_zone.main.name}"
}
