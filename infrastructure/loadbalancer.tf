resource "google_compute_region_backend_service" "pega-backend-service" {
  affinity_cookie_ttl_sec         = 0
  connection_draining_timeout_sec = 300
  enable_cdn                      = false
  health_checks = [
    google_compute_target_pool.pega-target-pool.id
  ]
  load_balancing_scheme = "INTERNAL"
  name                  = "pega-load-balancer"
  network               = google_compute_network.pega-network.id
  project               = "konvoy-gcp-se"
  protocol              = "TCP"
  region                = var.region
  session_affinity      = "NONE"
  timeout_sec           = 30

  backend {
    balancing_mode               = "CONNECTION"
    capacity_scaler              = 0
    failover                     = false
    group                        = google_compute_target_pool.pega-target-pool.id
    max_connections              = 0
    max_connections_per_endpoint = 0
    max_connections_per_instance = 0
    max_rate                     = 0
    max_rate_per_endpoint        = 0
    max_rate_per_instance        = 0
    max_utilization              = 0
  }
}

resource "google_compute_target_pool" "pega-target-pool" {
  instances     = google_compute_instance.pega-control-plane.*.self_link
  name          = "pega-target-pool"
  project       = var.project
  health_checks = [google_compute_http_health_check.pega-http-health-check.self_link]
}

resource "google_compute_http_health_check" "pega-http-health-check" {
  name               = "pega-http-health-check"
  request_path       = "/"
  timeout_sec        = 5
  check_interval_sec = 10
}
