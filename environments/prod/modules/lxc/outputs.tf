# prox-cicd/terraform/modules/lxc/outputs.tf

output "hostname" {
  description = "Hostname of the LXC container."
  value       = proxmox_lxc.container.hostname
}

output "vmid" {
  description = "VMID of the LXC container."
  value       = proxmox_lxc.container.vmid
}

output "ip" {
  description = "IP address of the LXC container."
  value       = proxmox_lxc.container.network[0].ip  # Adjust based on actual resource attributes
}