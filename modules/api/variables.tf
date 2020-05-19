variable "project" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "app_version" {
  type = "string"
}

variable "dns_domain" {
  type = "string"
}

variable "infra_project" {
  type = "string"
}

variable "dns_zone" {
  type = "string"
}

variable "builds_bucket" {
  type = "string"
}

variable "image_repository" {
  type = "string"
}

variable "replica_count" {
  type = "string"
}

variable "cpu_limit" {
  type = "string"
}

variable "memory_limit" {
  type = "string"
}

variable "cpu_request" {
  type = "string"
}

variable "memory_request" {
  type = "string"
}

variable "helm_repository" {
  type = "string"
}

variable "cloudbuild_sa" {
  type = "string"
}

variable "images_bucket" {
  type = "string"
}

variable "bucket_location" {
  type = "string"
}
