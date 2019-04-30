data "google_project" "project" {}

resource "google_container_cluster" "primary" {
  name   = "primary"
  region = "${var.region}"

  additional_zones = ["${var.zones}"]

  remove_default_node_pool = true
  initial_node_count       = 1

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name    = "primary"
  cluster = "${google_container_cluster.primary.name}"
  zone    = "${google_container_cluster.primary.zone}"
  region  = "${google_container_cluster.primary.region}"

  node_count = 1

  node_config {
    disk_size_gb = 10
    machine_type = "${var.machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/taskqueue"
    ]
  }
}

# TODO: remove this when Tiller is installed correctly through Terraform
resource "kubernetes_service_account" "tiller_service_account" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller_cluster_role_binding" {
  metadata {
    name = "tiller"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "kube-system"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.tiller_service_account.metadata.0.name}"
    namespace = "kube-system"
  }
}
