data "external" "facebook_scraper_env" {
  program = [
    "echo",
    "${data.google_kms_secret.facebook_scraper_env.plaintext}"]
}

resource "helm_release" "facebook_scraper" {
  name = "facebook-scraper"
  repository = "${var.helm_repository}"
  chart = "facebook-scraper"
  version = "${replace(var.app_version, "v", "")}"

  set_string {
    name  = "image.tag"
    value = "${var.app_version}"
  }

  set_string {
    name  = "image.repository"
    value = "${var.image_repository}"
  }

  set_string {
    name  = "scrapy.logLevel"
    value = "${var.scrapy_log_level}"
  }

  set_string {
    name  = "stackdriver.enabled"
    value = "true"
  }

  set_string {
    name  = "gcloud.project"
    value = "${var.project}"
  }
}

resource "kubernetes_secret" "facebook_scraper_env" {
  metadata {
    name = "facebook-scraper-env"
  }

  data {
    "ENV" = "production"
    "NG_API_HOST" = "https://api.nightguide.app"
    "NG_API_TOKEN" = "${data.external.facebook_scraper_env.result["NG_API_TOKEN"]}"
    "PROXY_POOL" = "${data.external.facebook_scraper_env.result["PROXY_POOL"]}"
    "MAIL_USER" = "apikey"
    "MAIL_PASS" = "${data.external.facebook_scraper_env.result["MAIL_PASS"]}"
    "MAIL_PORT" = "465"
    "MAIL_HOST" = "stmp.sendgrid.net"
    "MAIL_FROM" = "noreply@nightguide.app"
    "MAIL_SSL" = "True"
  }
}

resource "kubernetes_secret" "facebook_scraper_sa" {
  metadata {
    name = "facebook-scraper-sa"
  }

  data {
    "google-key.json" = "${base64decode(google_service_account_key.facebook_scraper_sa.private_key)}"
  }
}
