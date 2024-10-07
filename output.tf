# Output the names and types of the created servers
output "server_info" {
  value = [
    for instance in google_compute_instance.k8s-infra :
    {
      name = instance.name
      type = instance.machine_type
    }
  ]
}
