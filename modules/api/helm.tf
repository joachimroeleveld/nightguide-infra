locals {
  env_encrypted_uri = "gs://${var.builds_bucket}/secrets/api/${var.app_version}/env.${var.env}.enc"
}

data "google_storage_object_signed_url" "chart" {
  bucket = "${var.builds_bucket}"
  path   = "api/${var.app_version}/chart.tgz"
}

resource "helm_release" "api" {
  name       = "api"
  repository = "${var.helm_repository}"
  chart      = "api"
  version    = "${replace(var.app_version, "v", "")}"

  set_string {
    name  = "replicaCount"
    value = "${var.replica_count}"
  }

  set_string {
    name  = "containers.api.tag"
    value = "${var.app_version}"
  }

  set_string {
    name  = "containers.api.repository"
    value = "${var.image_repository}"
  }

  set_string {
    name  = "secrets.env.fileUri"
    value = "${local.env_encrypted_uri}"
  }

  set_string {
    name  = "secrets.env.kmsKeyRing"
    value = "${google_kms_key_ring.api.name}"
  }

  set_string {
    name  = "secrets.env.kmsKey"
    value = "${google_kms_crypto_key.env.name}"
  }

  set_string {
    name  = "secrets.serviceaccount.name"
    value = "api-serviceaccount"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set_string {
    name  = "ingress.hosts[0]"
    value = "${local.dns_name}"
  }

  set_string {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.allow-http"
    value = "false"
  }

  set_string {
    name  = "ingress.paths[0]"
    value = "/*"
  }

  set_string {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name"
    value = "${google_compute_global_address.api.name}"
  }

  set_string {
    name  = "ingress.annotations.ingress\\.gcp\\.kubernetes\\.io/pre-shared-cert"
    value = "${google_compute_managed_ssl_certificate.api.name}"
  }

  set {
    name  = "resources.limits.cpu"
    value = "${var.cpu_limit}"
  }

  set {
    name  = "resources.limits.memory"
    value = "${var.memory_limit}"
  }

  set {
    name  = "resources.requests.cpu"
    value = "${var.cpu_request}"
  }

  set {
    name  = "resources.requests.memory"
    value = "${var.memory_request}"
  }
}

resource "kubernetes_secret" "api_serviceaccount" {
  metadata {
    name = "api-serviceaccount"
  }

  data {
    "google-key.json" = "${base64decode(google_service_account_key.api_sa.private_key)}"
  }
}
