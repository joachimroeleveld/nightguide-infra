locals {
  appengine_sa = "serviceAccount:${var.project}@appspot.gserviceaccount.com"
}

resource "google_app_engine_application" "app" {
  project     = "${var.project}"
  location_id = "europe-west"
}

resource "google_project_iam_binding" "appengine_logwriter" {
  project = "${var.project}"
  role    = "roles/logging.logWriter"

  members = ["${local.appengine_sa}"]
}

// For GCR pulling
resource "google_project_iam_binding" "appengine_object_viewer" {
  project = "${var.project}"
  role    = "roles/storage.objectViewer"

  members = ["${local.appengine_sa}"]
}

resource "google_project_iam_binding" "appengine_trace_writer" {
  project = "${var.project}"
  role    = "roles/cloudtrace.agent"

  members = ["${local.appengine_sa}"]
}
