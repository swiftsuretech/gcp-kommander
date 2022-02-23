resource "google_compute_region_backend_service" "pega-backend-service" {
    affinity_cookie_ttl_sec         = 0
    connection_draining_timeout_sec = 300
    enable_cdn                      = false
    health_checks                   = [
        "https://www.googleapis.com/compute/v1/projects/konvoy-gcp-se/regions/us-central1/healthChecks/pega-health-check-t",
    ]
    load_balancing_scheme           = "INTERNAL"
    name                            = "pega-load-balancer"
    network                         = "google_compute_network.pega-network.id"
    project                         = "konvoy-gcp-se"
    protocol                        = "TCP"
    region                          = var.region
    session_affinity                = "NONE"
    timeout_sec                     = 30

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
    id        = "projects/konvoy-gcp-se/zones/us-central1-a/instanceGroups/pega-instance-group"
    instances = [
        "https://www.googleapis.com/compute/v1/projects/konvoy-gcp-se/zones/us-central1-a/instances/pega-control-plane0",
        "https://www.googleapis.com/compute/v1/projects/konvoy-gcp-se/zones/us-central1-a/instances/pega-control-plane1",
        "https://www.googleapis.com/compute/v1/projects/konvoy-gcp-se/zones/us-central1-a/instances/pega-control-plane2",
    ]
    name      = "pega-instance-group"
    network   = google_compute_network.pega-network.id
    project   = var.project
    size      = 3
    zone      = "us-central1-a"
}