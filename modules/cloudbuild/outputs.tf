output "image_repository" {
  value = "${data.google_container_registry_repository.builds.repository_url}"
}

output "builds_bucket" {
  value = "${local.builds_bucket}"
}

output "helm_repository" {
  value = "${local.helm_repository}"
}

output "cloudbuild_sa" {
  value = "${local.cloudbuild_sa}"
}

