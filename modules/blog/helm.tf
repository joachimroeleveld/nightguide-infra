data "external" "blog_secrets" {
  program = [
    "echo",
    "${data.google_kms_secret.blog_chart_values.plaintext}"]
}

resource "helm_release" "blog" {
  name = "blog"
  repository = "${var.helm_repository}"
  chart = "blog"
  version = "${replace(var.blog_version, "v", "")}"

  set_string {
    name = "image.repository"
    value = "${var.image_repository}"
  }

  set_string {
    name = "image.tag"
    value = "${var.blog_version}"
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
    value = "${google_compute_global_address.blog.name}"
  }

  set_string {
    name = "ingress.annotations.ingress\\.gcp\\.kubernetes\\.io/pre-shared-cert"
    value = "${google_compute_managed_ssl_certificate.blog.name}"
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
    name = "mariadb.resources.limits.cpu"
    value = "${var.mariadb_cpu_limit}"
  }

  set {
    name = "mariadb.resources.limits.memory"
    value = "${var.mariadb_memory_limit}"
  }

  set {
    name = "mariadb.resources.requests.cpu"
    value = "${var.mariadb_cpu_request}"
  }

  set {
    name = "mariadb.resources.requests.memory"
    value = "${var.mariadb_memory_request}"
  }

  set_string {
    name = "ghost.host"
    value = "${var.dns_name}"
  }

  set_string {
    name = "ghost.protocol"
    value = "${var.blog_protocol}"
  }

  set_string {
    name = "mariadb.db.password"
    value = "${data.external.blog_secrets.result["databaseConnectionPassword"]}"
  }
}

resource "kubernetes_secret" "blog_secrets" {
  metadata {
    name = "blog-secrets"
  }

  data {
    "mail__transport" = "${data.external.blog_secrets.result["mailTransport"]}"
    "mail__from" = "${data.external.blog_secrets.result["mailFrom"]}"
    "mail__options__host" = "${data.external.blog_secrets.result["mailOptionsHost"]}"
    "mail__options__port" = "${data.external.blog_secrets.result["mailOptionsPort"]}"
    "mail__options__service" = "${data.external.blog_secrets.result["mailOptionsService"]}"
    "mail__options__secure__connection" = "${data.external.blog_secrets.result["mailOptionsSecureConnection"]}"
    "mail__options__auth__user" = "${data.external.blog_secrets.result["mailOptionsAuthUser"]}"
    "mail__options__auth__pass" = "${data.external.blog_secrets.result["mailOptionsAuthPass"]}"
    "storage__active" = "${data.external.blog_secrets.result["storageMethod"]}"
    "storage__nightguideImages__projectId" = "${data.external.blog_secrets.result["projectId"]}"
    "storage__nightguideImages__bucket" = "${data.external.blog_secrets.result["imageBucket"]}"
    "storage__nightguideImages__imageServiceUrl" = "${data.external.blog_secrets.result["imageServiceUrl"]}"
    "storage__nightguideImages__imageServiceToken" = "${data.external.blog_secrets.result["imageServiceToken"]}"
    "storage__nightguideImages__maxAge" = "${data.external.blog_secrets.result["imagesMaxAge"]}"
    "database__client" = "${data.external.blog_secrets.result["databaseClient"]}"
    "database__connection__host" = "${data.external.blog_secrets.result["databaseConnectionHost"]}"
    "database__connection__port" = "${data.external.blog_secrets.result["databaseConnectionPort"]}"
    "database__connection__user" = "${data.external.blog_secrets.result["databaseConnectionUser"]}"
    "database__connection__password" = "${data.external.blog_secrets.result["databaseConnectionPassword"]}"
    "database__connection__database" = "${data.external.blog_secrets.result["databaseConnectionDatabase"]}"
  }
}

resource "kubernetes_secret" "blog_serviceaccount" {
  metadata {
    name = "blog-serviceaccount"
  }

  data {
    "google-key.json" = "${base64decode(google_service_account_key.blog_sa.private_key)}"
  }
}
