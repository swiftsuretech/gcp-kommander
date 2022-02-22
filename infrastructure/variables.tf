variable "project" {
  type    = string
  default = "konvoy-gcp-se"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "worker_count" {
  type    = number
  default = 4
}

variable "controlplane_count" {
  type    = number
  default = 3
}

variable "service_account" {
  type    = string
  default = "dswhitehouse@konvoy-gcp-se.iam.gserviceaccount.com"
}
variable "private_key" {
  type    = string
  default = "../keys/pega"
}

variable "ssh_username" {
  type    = string
  default = "dswhitehouse"
}

variable "cluster_name" {
  type    = string
  default = "pega-cluster"
}

variable "public_key" {
  type = string
}