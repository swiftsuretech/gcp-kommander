resource "google_compute_instance" "pega-bastion" {
  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false
  guest_accelerator   = []
  hostname            = "bastionnetwork.pega"
  labels = {
    "owner" = var.owner
  }
  machine_type = "e2-standard-4"
  metadata = {
    "ssh-keys" = var.public_key
  }
  name              = "pega-bastion"
  project           = "konvoy-gcp-se"
  resource_policies = []
  tags = [
    "pega",
  ]
  zone = "us-central1-a"

  boot_disk {
    auto_delete = true
    device_name = "pega-bastion"
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
    network_ip         = "10.0.0.10"
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
    source      = "../keys/pega"
    destination = "/home/${var.ssh_username}/.ssh/pega"
    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.private_key)
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  provisioner "file" {
    source      = "../configuration/setup-dkp"
    destination = "/home/${var.ssh_username}/setup-dkp"
    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.private_key)
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }


  provisioner "file" {
    source      = "../configuration/setup-bastion"
    destination = "/tmp/script.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.private_key)
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  provisioner "file" {
    source      = "../binaries/dkp"
    destination = "/tmp/dkp"
    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.private_key)
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  provisioner "file" {
    source      = "../binaries/kommander"
    destination = "/tmp/kommander"
    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.private_key)
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
      "chmod +x /tmp/dkp",
      "chmod +x /home/${var.ssh_username}/setup-dkp",
      "chmod 400 /home/${var.ssh_username}/.ssh/pega"
    ]
    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.private_key)
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }
}

resource "local_file" "public_ip" {
  content  = google_compute_instance.pega-bastion.network_interface[0].access_config[0].nat_ip
  filename = "external_ip_addr"
}
