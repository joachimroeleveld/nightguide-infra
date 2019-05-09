// TODO: move to modules once upgraded to 0.12 (conditional arguments)

resource "google_sourcerepo_repository" "api" {
  project = "${var.infra_project}"
  name    = "github_joachimroeleveld_nightguide-api"
}

//resource "google_cloudbuild_trigger" "api" {
//  project = "${var.infra_project}"
//
//  trigger_template {
//    branch_name = "master"
//    repo_name   = "${google_sourcerepo_repository.api.name}"
//  }
//
//  substitutions = {
//    _PROJECT       = "${var.project}"
//    _ENV           = "${var.env}"
//    _IMAGE_REPO    = "${module.cloudbuild.image_repository}"
//    _BUILDS_BUCKET = "${module.cloudbuild.builds_bucket}"
//  }
//
//  filename = "cloudbuild-deploy.yaml"
//}
