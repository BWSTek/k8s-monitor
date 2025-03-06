# prox-cicd/terraform/modules/lxc/variables.tf

variable "hostname" {
  description = "Hostname of the LXC container."
  type        = string
}

variable "target_node" {
  description = "Proxmox target node."
  type        = string
}

variable "vmid" {
  description = "VMID for the container."
  type        = number
}

variable "ostemplate" {
  description = "OSTemplate to use for the container."
  type        = string
}

variable "ostype" {
  description = "Operating system type."
  type        = string
}

variable "memory" {
  description = "Memory allocated to the container in MB."
  type        = number
}

variable "root_password" {
  description = "Root password for the container."
  type        = string
  sensitive   = true
}

variable "cores" {
  description = "Number of CPU cores allocated."
  type        = number
}

variable "unprivileged" {
  description = "Unprivileged container flag."
  type        = bool
}

variable "start" {
  description = "Start container after creation."
  type        = bool
}

variable "onboot" {
  description = "Enable container on boot."
  type        = bool
}

variable "swap" {
  description = "Swap memory allocated to the container in MB."
  type        = number
}

variable "tty" {
  description = "Number of TTYs."
  type        = number
}

variable "protection" {
  description = "Protection flag for the container."
  type        = bool
}

variable "ssh_public_keys" {
  description = "SSH public keys for container access."
  type        = string
  default     = ""
}

variable "rootfs_storage" {
  description = "Storage type for root filesystem."
  type        = string
}

variable "disk_size" {
  description = "Disk size allocated for the container."
  type        = string
}

variable "features_fuse" {
  description = "Enable FUSE feature."
  type        = bool
  default     = false
}

variable "features_keyctl" {
  description = "Enable KEYCTL feature."
  type        = bool
  default     = false
}

variable "features_mknod" {
  description = "Enable MKNOD feature."
  type        = bool
  default     = false
}

variable "features_nesting" {
  description = "Enable NESTING feature."
  type        = bool
  default     = true
}

variable "network_bridge" {
  description = "Network bridge for the container."
  type        = string
}

variable "gateway_ip" {
  description = "Gateway IP address."
  type        = string
}

variable "ip" {
  description = "IP address for the container."
  type        = string
  default     = "dhcp"
}

variable "network_name" {
  description = "Network interface name."
  type        = string
}

variable "network_tag" {
  description = "Network tag."
  type        = string
}

variable "network_type" {
  description = "Type of network interface."
  type        = string
}