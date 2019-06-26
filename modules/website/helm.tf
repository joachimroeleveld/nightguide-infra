data "external" "website_env" {
  program = [
    "echo",
    "${data.google_kms_secret.website_env.plaintext}"]
}

resource "helm_release" "website" {
  name = "website"
  repository = "${var.helm_repository}"
  chart = "website"
  version = "${replace(var.website_version, "v", "")}"

  set_string {
    name  = "containers.website.repository"
    value = "${var.image_repository}/website"
  }

  set_string {
    name = "containers.website.tag"
    value = "${var.website_version}"
  }

  set {
    name = "ingress.enabled"
    value = "true"
  }

  set_string {
    name = "service.type"
    value = "NodePort"
  }

  set_string {
    name = "ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name"
    value = "${google_compute_global_address.website.name}"
  }

  set_string {
    name = "ingress.annotations.ingress\\.gcp\\.kubernetes\\.io/pre-shared-cert"
    value = "${google_compute_managed_ssl_certificate.website.name}\\, ${google_compute_managed_ssl_certificate.website_www.name}"
  }

  set_string {
    name = "replicaCount"
    value = "${var.replica_count}"
  }

  set {
    name = "containers.website.resources.limits.cpu"
    value = "${var.cpu_limit}"
  }

  set {
    name = "containers.website.resources.limits.memory"
    value = "${var.memory_limit}"
  }

  set {
    name = "containers.website.resources.requests.cpu"
    value = "${var.cpu_request}"
  }

  set {
    name = "containers.website.resources.requests.memory"
    value = "${var.memory_request}"
  }

  set {
    name = "containers.nginx.resources.limits.cpu"
    value = "${var.nginx_cpu_limit}"
  }

  set {
    name = "containers.nginx.resources.limits.memory"
    value = "${var.nginx_memory_limit}"
  }

  set {
    name = "containers.nginx.resources.requests.cpu"
    value = "${var.nginx_cpu_request}"
  }

  set {
    name = "containers.nginx.resources.requests.memory"
    value = "${var.nginx_memory_request}"
  }
}

resource "kubernetes_secret" "website_env" {
  metadata {
    name = "website-env"
  }

  data {
    "NODE_ENV" = "${data.external.website_env.result["NODE_ENV"]}"
  }
}
