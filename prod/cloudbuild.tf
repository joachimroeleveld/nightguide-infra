// TODO: move to modules once upgraded to 0.12 (conditional arguments)

resource "google_sourcerepo_repository" "api" {
  project = "${var.infra_project}"
  name    = "github_joachimroeleveld_nightguide-api"
}

resource "google_sourcerepo_repository" "facebook_scraper" {
  project = "${var.infra_project}"
  name    = "github_joachimroeleveld_nightguide-facebook-scraper"
}

resource "google_sourcerepo_repository" "blog" {
  project = "${var.infra_project}"
  name    = "github_joachimroeleveld_nightguide-blog"
}

resource "google_sourcerepo_repository" "admin" {
  project = "${var.infra_project}"
  name    = "github_joachimroeleveld_nightguide-admin"
}

resource "google_sourcerepo_repository" "website" {
  project = "${var.infra_project}"
  name    = "github_joachimroeleveld_nightguide-website"
}

resource "google_cloudbuild_trigger" "api" {
  project = "${var.infra_project}"

  trigger_template {
    tag_name  = "v.*"
    repo_name = "${google_sourcerepo_repository.api.name}"
  }

  substitutions = {
    _PROJECT       = "${var.project}"
    _ENV           = "${var.env}"
    _IMAGE_REPO    = "${module.cloudbuild.image_repository}"
    _BUILDS_BUCKET = "${module.cloudbuild.builds_bucket}"
  }

  filename = "cloudbuild-deploy.yaml"
}

resource "google_cloudbuild_trigger" "facebook_scraper" {
  project = "${var.infra_project}"

  trigger_template {
    tag_name  = "v.*"
    repo_name = "${google_sourcerepo_repository.facebook_scraper.name}"
  }

  substitutions = {
    _ENV           = "${var.env}"
    _IMAGE_REPO    = "${module.cloudbuild.image_repository}"
    _BUILDS_BUCKET = "${module.cloudbuild.builds_bucket}"
  }

  filename = "cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "blog" {
  project = "${var.infra_project}"

  trigger_template {
    tag_name  = "v.*"
    repo_name = "${google_sourcerepo_repository.blog.name}"
  }

  substitutions = {
    _ENV           = "${var.env}"
    _IMAGE_REPO    = "${module.cloudbuild.image_repository}"
    _BUILDS_BUCKET = "${module.cloudbuild.builds_bucket}"
  }

  filename = "cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "admin" {
  project = "${var.infra_project}"

  trigger_template {
    tag_name  = "v.*"
    repo_name = "${google_sourcerepo_repository.admin.name}"
  }

  substitutions = {
    _ENV           = "${var.env}"
    _IMAGE_REPO    = "${module.cloudbuild.image_repository}"
    _BUILDS_BUCKET = "${module.cloudbuild.builds_bucket}"
  }

  filename = "cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "website" {
  project = "${var.infra_project}"

  trigger_template {
    tag_name  = "v.*"
    repo_name = "${google_sourcerepo_repository.website.name}"
  }

  substitutions = {
    _ENV           = "${var.env}"
    _IMAGE_REPO    = "${module.cloudbuild.image_repository}"
    _BUILDS_BUCKET = "${module.cloudbuild.builds_bucket}"
  }

  filename = "cloudbuild.yaml"
}
