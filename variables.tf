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

/*
you need to give server name like the below. if not its wont work.
haproxy, k8s-master-1,k8s-master-2, k8s-master-3, k8s-worker-1, k8s-worker-2, k8s-worker-3
*/
variable "server_names" {
  type    = list(string)
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

variable "private_ips" {
  type = map(string)
  default = {
    "haproxy"       = "10.128.0.2"
    "k8s-master-1"  = "10.128.0.3"
    "k8s-master-2"  = "10.128.0.4"
    "k8s-master-3"  = "10.128.0.5"
    "k8s-worker-1"  = "10.128.0.6"
    "k8s-worker-2"  = "10.128.0.7"
    "k8s-worker-3"  = "10.128.0.8"
  }
}

