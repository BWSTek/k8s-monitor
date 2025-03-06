variable "hostname" {
  description = "The hostname of the VM"
  type        = string
}

variable "target_node" {
  description = "The Proxmox node to create the VM on"
  type        = string
}

variable "vmid" {
  description = "The ID of the VM"
  type        = number
}

variable "memory" {
  description = "Amount of RAM for the VM (in MB)"
  type        = number
  default     = 2048
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "onboot" {
  description = "Whether to start the VM on boot"
  type        = bool
  default     = true
}

variable "vm_state" {
  description = "State of the VM after creation (running or stopped)"
  type        = string
  default     = "running"
}

variable "ciuser" {
  description = "Cloud-init user name"
  type        = string
  default     = "ubuntu"
}

variable "cipassword" {
  description = "Cloud-init user password"
  type        = string
  sensitive   = true
  default     = null
}

variable "searchdomain" {
  description = "Cloud-init search domain"
  type        = string
  default     = null
}

variable "nameserver" {
  description = "Cloud-init DNS server"
  type        = string
  default     = null
}

variable "ipconfig" {
  description = "Cloud-init IP configuration (e.g., 'ip=dhcp' or 'ip=10.0.0.3/24,gw=10.0.0.1')"
  type        = string
  default     = "ip=dhcp"
}

variable "disk_type" {
  description = "Type of disk device"
  type        = string
  default     = "scsi"
}

variable "storage_pool" {
  description = "Storage pool for the disk"
  type        = string
}

variable "disk_size" {
  description = "Size of the disk in GB"
  type        = string
  default     = "32G"
}

variable "disk_format" {
  description = "Format of the disk"
  type        = string
  default     = "raw"
}

variable "disk_ssd" {
  description = "Enable SSD emulation for the disk"
  type        = bool
  default     = true
}

variable "disk_discard" {
  description = "Enable discard support (useful for SSD storage)"
  type        = bool
  default     = true
}

variable "disk_iothread" {
  description = "Enable IO threads for the disk"
  type        = bool
  default     = true
}

variable "disk_cache" {
  description = "Disk cache mode. Options: none, writethrough, writeback, unsafe, directsync"
  type        = string
  default     = "none"
}

variable "network_bridge" {
  description = "Network bridge to attach the VM to"
  type        = string
  default     = "vmbr0"
}

variable "network_model" {
  description = "Network card model"
  type        = string
  default     = "virtio"
}

variable "network_tag" {
  description = "VLAN tag"
  type        = number
  default     = null
}

variable "boot" {
  description = "Boot order for the VM"
  type        = string
  default     = "c"
}

variable "bootdisk" {
  description = "Boot disk for the VM"
  type        = string
  default     = "scsi0"
}

variable "scsihw" {
  description = "SCSI controller model"
  type        = string
  default     = "virtio-scsi-pci"
}

variable "vga" {
  description = "VGA type"
  type        = string
  default     = "std"
}

variable "ssh_public_keys" {
  description = "SSH public keys to add to the VM"
  type        = string
}