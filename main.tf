# Create multiple servers with custom CPU, Memory, and 20GB disk
resource "google_compute_instance" "k8s-infra" {
  for_each     = toset(var.server_names)
  name         = each.value
  zone         = var.zones[each.value]

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
# Assign the custom private IP from the mapping
    network_ip = lookup(var.private_ips, each.value, null)

  }
  # Install Docker on VMs with names starting with 'worker-'
  metadata_startup_script = (
  startswith(each.value, "haproxy") ? file("./haproxy.sh") :
  startswith(each.value, "k8s-master-") ? file("./kube_master_prep.sh") :
  startswith(each.value, "k8s-worker-") ? file("./kube_worker_prep.sh") :
  null  # Fallback if no match
  )
}

