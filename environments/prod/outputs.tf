## Namespaces

output "grafana_namespace" {
  value = module.namespace.grafana_namespace
}

output "prometheus_namespace" {
  value = module.namespace.prometheus_namespace
}

# Output the credentials to use in the Authentik UI
output "grafana_client_id" {
  value = random_string.grafana_client_id.result
  sensitive = false
}

output "grafana_client_secret" {
  value = random_password.grafana_client_secret.result
  sensitive = true
}

# Output the hostname for verification
output "proxmox_host" {
  value = local.proxmox_host
}