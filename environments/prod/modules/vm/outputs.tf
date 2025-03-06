output "vmid" {
  description = "The ID of the created VM"
  value       = proxmox_vm_qemu.vm.vmid
}

output "name" {
  description = "The name of the VM"
  value       = proxmox_vm_qemu.vm.name
}

output "ip_address" {
  description = "IP address of the VM"
  value       = proxmox_vm_qemu.vm.default_ipv4_address
}
