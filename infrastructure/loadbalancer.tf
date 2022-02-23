resource "google_compute_region_backend_service" "pega-backend-service" {
  affinity_cookie_ttl_sec         = 0
  connection_draining_timeout_sec = 300
  enable_cdn                      = false
  health_checks = [
    "google_compute_instance_group.pega-instance-group.id"
  ]
  load_balancing_scheme = "INTERNAL"
  name                  = "pega-load-balancer"
  network               = "google_compute_network.pega-network.id"
  project               = "konvoy-gcp-se"
  protocol              = "TCP"
  region                = var.region
  session_affinity      = "NONE"
  timeout_sec           = 30

  backend {
    balancing_mode               = "CONNECTION"
    capacity_scaler              = 0
    failover                     = false
    group                        = "https://www.googleapis.com/compute/v1/projects/konvoy-gcp-se/zones/us-central1-a/instanceGroups/pega-instance-group"
    max_connections              = 0
    max_connections_per_endpoint = 0
    max_connections_per_instance = 0
    max_rate                     = 0
    max_rate_per_endpoint        = 0
    max_rate_per_instance        = 0
    max_utilization              = 0
  }
}

resource "google_compute_instance_group" "pega-instance-group" {
  instances = [
    "google_compute_instance.pega-control-plane0.id",
  ]
  name    = "pega-instance-group"
  network = google_compute_network.pega-network.id
  project = var.project
  zone    = "us-central1-a"
}

resource "google_compute_health_check" "pega-health-check" {
  name = "pega-health-check"

  timeout_sec        = 5
  check_interval_sec = 10

  tcp_health_check {
    port = "80"
  }
}