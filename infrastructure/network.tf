resource "google_compute_network" "pega-network" {
  auto_create_subnetworks         = true
  delete_default_routes_on_create = false
  mtu                             = 0
  name                            = "pega-network"
  project                         = "konvoy-gcp-se"
  routing_mode                    = "REGIONAL"
}

resource "google_compute_subnetwork" "pega-subnet" {
  ip_cidr_range              = "10.0.0.0/16"
  name                       = "pega-subnet"
  network                    = "google_compute_network.pega-network.id"
  private_ip_google_access   = false
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  project                    = "konvoy-gcp-se"
  purpose                    = "PRIVATE"
  region                     = "us-central1"
  secondary_ip_range         = []
  stack_type                 = "IPV4_ONLY"
  depends_on                 = [google_compute_network.pega-network]
}

resource "google_compute_firewall" "pega-internal" {
  direction  = "INGRESS"
  depends_on = [google_compute_network.pega-network]
  disabled   = false
  name       = "pega-internal"
  network    = "https://www.googleapis.com/compute/v1/projects/konvoy-gcp-se/global/networks/pega-network"
  priority   = 1000
  project    = "konvoy-gcp-se"
  source_ranges = [
    "0.0.0.0/0",
  ]
  target_service_accounts = [
    var.service_account,
  ]
  allow {
    protocol = "all"
  }
  allow {
    ports    = []
    protocol = "icmp"
  }
}