resource "helm_release" "scrapyd" {
  name = "scrapyd"
  repository = "${var.helm_repository}"
  chart = "scrapyd"
  version = "${replace(var.app_version, "v", "")}"

  set {
    name = "ingress.enabled"
    value = "true"
  }

  set_string {
    name = "ingress.rules.spiderkeeper.host"
    value = "${var.dns_name}"
  }

  set_string {
    name = "ingress.annotations.kubernetes\\.io/ingress\\.allow-http"
    value = "false"
  }

  set_string {
    name = "ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name"
    value = "${google_compute_global_address.scrapyd.name}"
  }

  set_string {
    name = "ingress.annotations.ingress\\.gcp\\.kubernetes\\.io/pre-shared-cert"
    value = "${google_compute_managed_ssl_certificate.scrapyd.name}"
  }

  set_string {
    name  = "containers.scrapyd.proxyPool"
    value = "198.46.251.237:80:drjbvaer:9bac86b6f7\\,185.158.134.163:80:drjbvaer:9bac86b6f7\\,196.245.186.247:80:drjbvaer:9bac86b6f7\\,198.46.251.206:80:drjbvaer:9bac86b6f7\\,185.158.134.174:80:drjbvaer:9bac86b6f7\\,196.245.186.130:80:drjbvaer:9bac86b6f7\\,185.158.133.147:80:drjbvaer:9bac86b6f7\\,196.245.186.108:80:drjbvaer:9bac86b6f7\\,5.157.29.185:80:drjbvaer:9bac86b6f7\\,198.46.251.200:80:drjbvaer:9bac86b6f7"
  }
}

resource "kubernetes_secret" "scrapyd_secrets" {
  metadata {
    name = "scrapyd-secrets"
  }

  data {
    "scrapy_env" = "${data.google_kms_secret.scrapy_env.plaintext}"
  }
}
