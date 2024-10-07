# Create multiple servers with custom CPU, Memory, and 20GB disk
resource "google_compute_instance" "k8s-infra" {
  for_each     = toset(var.server_names)
  name         = each.value
  zone         = "us-central1-a"

  # Custom machine type created using CPU and memory values
  machine_type = "custom-${var.cpu}-${var.memory * 1024}"  # Memory is specified in MB

  # Boot disk with CentOS image and 20GB size
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-stream-9"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {
      // This block provides the external IP
    }
  }


}
