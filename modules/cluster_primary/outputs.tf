output "cluster_certificate" {
  value = "${base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}"
}

output "cluster_endpoint" {
  value = "${google_container_cluster.primary.endpoint}"
}