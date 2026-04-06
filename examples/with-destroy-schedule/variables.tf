variable "environment" {
  type = string
}

variable "project_code" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "base_name" {
  type = string
}

variable "key_ring_name" {
  type = string
}

variable "destroy_scheduled_duration" {
  type    = string
  default = "86400s"
}
