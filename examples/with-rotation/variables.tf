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

variable "rotation_period" {
  type    = string
  default = "7776000s"
}
