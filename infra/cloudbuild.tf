resource "google_sourcerepo_repository" "docker_gcloud_make" {
  name = "github_joachimroeleveld_docker-gcloud-make"
}

resource "google_cloudbuild_trigger" "docker_gcloud_make" {
  trigger_template {
    tag_name  = "v.*"
    repo_name = "${google_sourcerepo_repository.docker_gcloud_make.name}"
  }

  filename = "cloudbuild.yaml"
}
