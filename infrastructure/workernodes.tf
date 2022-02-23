resource "google_compute_instance" "pega-worker-node" {
  count               = var.worker_count
  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false
  guest_accelerator   = []
  hostname            = "workernode${count.index}.pega"
  labels = {
    "owner" = var.owner
  }
  machine_type = "e2-standard-8"
  metadata = {
    "ssh-keys" = var.public_key
  }
  name              = "pega-worker-node${count.index}"
  project           = "konvoy-gcp-se"
  resource_policies = []
  tags = [
    "pega",
  ]
  zone = "us-central1-a"

  boot_disk {
    auto_delete = true
    device_name = "pega-worker-node${count.index}"
    mode        = "READ_WRITE"

    initialize_params {
      image  = "https://www.googleapis.com/compute/v1/projects/centos-cloud/global/images/centos-7-v20220126"
      labels = {}
      size   = 100
      type   = "pd-balanced"
    }
  }

  confidential_instance_config {
    enable_confidential_compute = false
  }

  network_interface {
    network            = google_compute_network.pega-network.id
    network_ip         = "10.0.0.3${count.index}"
    queue_count        = 0
    stack_type         = "IPV4_ONLY"
    subnetwork         = google_compute_subnetwork.pega-subnet.id
    subnetwork_project = "konvoy-gcp-se"
    access_config {
      network_tier = "PREMIUM"
    }
  }

  reservation_affinity {
    type = "ANY_RESERVATION"
  }

  service_account {
    email = var.service_account
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  provisioner "file" {
    source      = "../configuration/setup-host"
    destination = "/tmp/setup-host"
    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.private_key)
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup-host",
      "/tmp/setup-host args",
    ]
    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.private_key)
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

}
