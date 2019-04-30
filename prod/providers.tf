provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${file("${path.module}/../deploy-key.json")}"
}

provider "google-beta" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${file("${path.module}/../deploy-key.json")}"
}

provider "kubernetes" {
  config_context = "gke_nightguide-app-prod_europe-west1_primary"
}

provider "helm" {
  version = "~> 0.9.0"

  kubernetes {
    config_context = "gke_nightguide-app-prod_europe-west1_primary"
  }
}
