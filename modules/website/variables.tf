variable "env" {
  type = "string"
}

variable "image_repository" {
  type = "string"
}

variable "helm_repository" {
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

variable "nginx_cpu_limit" {
  type = "string"
}

variable "nginx_memory_limit" {
  type = "string"
}

variable "nginx_cpu_request" {
  type = "string"
}

variable "nginx_memory_request" {
  type = "string"
}

variable "dns_domain" {
  type = "string"
}

variable "dns_zone" {
  type = "string"
}

variable "blog_protocol" {
  type = "string"
}

variable "website_version" {
  type = "string"
}

variable "blog_version" {
  type = "string"
}

variable "ghost_version" {
  type = "string"
}
