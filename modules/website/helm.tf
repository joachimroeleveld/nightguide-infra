data "external" "ghost_secrets" {
  program = [
    "echo",
    "${data.google_kms_secret.ghost_chart_values.plaintext}"]
}

resource "helm_release" "ghost" {
  name = "ghost"
  repository = "${var.helm_repository}"
  chart = "ghost"
  version = "${replace(var.blog_version, "v", "")}"

  set_string {
    name = "image.tag"
    value = "${var.ghost_version}"
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
    value = "${var.dns_name}"
  }

  set_string {
    name = "ingress.hosts[0].paths[0]"
    value = "/*"
  }

  set_string {
    name = "ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name"
    value = "${google_compute_global_address.website.name}"
  }

  set_string {
    name = "ingress.annotations.ingress\\.gcp\\.kubernetes\\.io/pre-shared-cert"
    value = "${google_compute_managed_ssl_certificate.website.name}"
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

  set {
    name = "ghost.host"
    value = "${var.dns_name}"
  }

  set {
    name = "ghost.protocol"
    value = "${var.blog_protocol}"
  }
}

resource "kubernetes_secret" "ghost_secrets" {
  metadata {
    name = "ghost-secrets"
  }

  data {
    "mail__transport" = "${data.external.ghost_secrets.result["mailTransport"]}"
    "mail__from" = "${data.external.ghost_secrets.result["mailFrom"]}"
    "mail__options__host" = "${data.external.ghost_secrets.result["mailOptionsHost"]}"
    "mail__options__port" = "${data.external.ghost_secrets.result["mailOptionsPort"]}"
    "mail__options__service" = "${data.external.ghost_secrets.result["mailOptionsService"]}"
    "mail__options__secure__connection" = "${data.external.ghost_secrets.result["mailOptionsSecureConnection"]}"
    "mail__options__auth__user" = "${data.external.ghost_secrets.result["mailOptionsAuthUser"]}"
    "mail__options__auth__pass" = "${data.external.ghost_secrets.result["mailOptionsAuthPass"]}"
  }
}
