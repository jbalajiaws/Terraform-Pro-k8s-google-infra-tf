# Define the list of server zones
variable "zones" {
  type = map(string)
  default = {
    "haproxy" = "us-central1-c"
    "k8s-master-1" = "us-central1-c"
    "k8s-master-2" = "us-central1-c"
    "k8s-master-3" = "us-central1-c"
    "k8s-worker-1"     = "us-central1-c"
    "k8s-worker-2"     = "us-central1-c"
  }
}

# Define the list of server names
variable "server_names" {
  type    = list(string)
  #default = ["k8s-master-1", "k8s-master-2", "k8s-master-3", "worker-1"]
  default = ["haproxy", "k8s-master-1", "k8s-master-2"]
}

# Variables for custom CPU and Memory values
variable "cpu" {
  type    = number
  default = 2  # Default to 2 vCPUs
}

variable "memory" {
  type    = number
  default = 4  # Default to 4GB memory
}