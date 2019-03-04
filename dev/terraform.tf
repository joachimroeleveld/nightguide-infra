terraform {
  backend "gcs" {
    bucket = "tf-state.nightguide.app"
    prefix = "dev"
  }
}
