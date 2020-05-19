resource "helm_release" "admin" {
  name = "admin"
  repository = "${var.helm_repository}"
  chart = "admin"
  version = "${replace(var.admin_version, "v", "")}"

  set_string {
    name = "image.repository"
    value = "${var.image_repository}/admin"
  }

  set_string {
    name = "image.tag"
    value = "${var.admin_version}"
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
    name = "ingress.hosts[0].host"
    value = "${local.dns_name}"
  }

  set_string {
    name = "ingress.hosts[0].paths[0]"
    value = "/*"
  }

  set_string {
    name = "ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name"
    value = "${google_compute_global_address.admin.name}"
  }

  set_string {
    name = "ingress.annotations.ingress\\.gcp\\.kubernetes\\.io/pre-shared-cert"
    value = "${google_compute_managed_ssl_certificate.admin.name}"
  }

  set_string {
    name = "replicaCount"
    value = "${var.replica_count}"
  }

  set {
    name = "resources.limits.cpu"
    value = "${var.cpu_limit}"
  }

  set {
    name = "resources.limits.memory"
    value = "${var.memory_limit}"
  }

  set {
    name = "resources.requests.cpu"
    value = "${var.cpu_request}"
  }

  set {
    name = "resources.requests.memory"
    value = "${var.memory_request}"
  }
}
