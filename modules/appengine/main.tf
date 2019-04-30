locals {
  appengine_sa = "serviceAccount:${var.project}@appspot.gserviceaccount.com"
}

resource "google_app_engine_application" "app" {
  project     = "${var.project}"
  location_id = "europe-west"
}

resource "google_project_iam_member" "appengine_logwriter" {
  project = "${var.project}"
  role    = "roles/logging.logWriter"

  member = "${local.appengine_sa}"
}

// For GCR pulling
resource "google_project_iam_member" "appengine_object_viewer" {
  project = "${var.project}"
  role    = "roles/storage.objectViewer"

  member = "${local.appengine_sa}"
}

resource "google_project_iam_member" "appengine_trace_writer" {
  project = "${var.project}"
  role    = "roles/cloudtrace.agent"

  member = "${local.appengine_sa}"
}
