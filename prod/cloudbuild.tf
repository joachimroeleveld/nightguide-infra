// TODO: move to modules once upgraded to 0.12 (conditional arguments)

resource "google_sourcerepo_repository" "api" {
  project = "${var.infra_project}"
  name    = "github_joachimroeleveld_nightguide-api"
}

resource "google_cloudbuild_trigger" "api" {
  project = "${var.infra_project}"

  trigger_template {
    tag_name  = "v.*"
    repo_name = "${google_sourcerepo_repository.api.name}"
  }

  substitutions = {
    _ENV = "${var.env}"
  }

  filename = "cloudbuild-deploy.yaml"
}
