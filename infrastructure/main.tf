provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

locals {
  bastion_l = google_compute_instance.pega-bastion.network_interface.0.access_config.0.nat_ip
  connect   = "ssh -i keys/pega $local.bastion_1"
}

output "output" {
  value = local.connect
}
