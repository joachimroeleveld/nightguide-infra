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

module "admin" {
  source = "../modules/admin"

  env = "${var.env}"
  helm_repository = "${module.cloudbuild.helm_repository}"
  image_repository = "${module.cloudbuild.image_repository}"

  dns_zone = "${google_dns_managed_zone.main.name}"
  dns_domain = "${var.dns_name}"

  replica_count = 1
  cpu_limit = "0.2"
  cpu_request = "0.05"
  memory_limit = "200M"
  memory_request = "100M"

  admin_version = "${var.admin_version}"
}

module "website" {
  source = "../modules/website"

  env = "${var.env}"
  helm_repository = "${module.cloudbuild.helm_repository}"
  image_repository = "${module.cloudbuild.image_repository}"

  dns_zone = "${google_dns_managed_zone.main.name}"
  dns_domain = "${var.dns_name}"

  replica_count = 1
  cpu_limit = "0.5"
  cpu_request = "0.2"
  memory_limit = "500M"
  memory_request = "200M"
  nginx_cpu_limit = "0.3"
  nginx_cpu_request = "0.1"
  nginx_memory_limit = "300M"
  nginx_memory_request = "100M"

  website_version = "${var.website_version}"
  blog_protocol = "https"
  blog_version = "v1.1.3"
  ghost_version = "2.22-alpine"
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
  bucket_location = "${var.bucket_location}"

  replica_count = 1
  cpu_limit = "0.5"
  cpu_request = "0.1"
  memory_limit = "500M"
  memory_request = "150M"

  dns_domain = "${var.dns_name}"
  dns_zone = "${google_dns_managed_zone.main.name}"

  images_bucket = "${module.images.bucket_name}"
}

module "facebook_scraper" {
  source = "../modules/facebook_scraper"

  env = "${var.env}"
  project = "${var.project}"

  app_version      = "${var.facebook_scraper_version}"
  image_repository = "${module.cloudbuild.image_repository}"
  helm_repository  = "${module.cloudbuild.helm_repository}"

  scrapy_log_level = "DEBUG"
}

module "static" {
  source = "../modules/static"

  bucket_location = "${var.bucket_location}"
  bucket_name = "static.${var.dns_name}"

  dns_domain = "${var.dns_name}"
  dns_data = [
    "35.244.195.251",
  ]
  dns_zone = "${google_dns_managed_zone.main.name}"
}

module "images" {
  source = "../modules/images"

  bucket_location = "${var.bucket_location}"
  bucket_name = "images.${var.dns_name}"

  dns_domain = "${var.dns_name}"
  dns_data = [
    "ghs.googlehosted.com.",
  ]
  dns_zone = "${google_dns_managed_zone.main.name}"
}
