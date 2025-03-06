variable "target_node" {
  description = "The Proxmox node to create the VMs on"
  type        = string
  default     = "js-1"  # Change this to your Proxmox node name
}

variable "proxmox_api_url" {
  description = "The URL of the Proxmox API"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "The ID of the Proxmox API token"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "The secret of the Proxmox API token"
  type        = string
  sensitive   = true
}

# Optional: Override these variables if needed
variable "ssh_public_key" {
  type        = string
  description = "Path to SSH public key file (will use corresponding private key)"
  default     = "~/.ssh/id_rsa.pub"  # Default path, adjust as needed
}

variable "network_bridge" {
  description = "The network bridge to use for the VMs"
  type        = string
  default     = "vmbr0"
}

variable "storage_pool" {
  description = "The storage pool to use for the VMs"
  type        = string
  default     = "local-lvm"
}

variable "base_network" {
  description = "The base network CIDR for the VMs"
  type        = string
  default     = "192.168.1.0/24"
}

variable "vm_user" {
  description = "The username to create in the VMs"
  type        = string
  default     = "jordan"
}

variable "vm_state" {
  description = "State of the VM after creation (running or stopped)"
  type        = string
  default     = "running"
}

variable "gateway_ip" {
  description = "The gateway IP for the VMs"
  type        = string
  default     = "192.168.1.1"
}

## K8s configuration
variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "nfs_server" {
  description = "NFS server address"
  type        = string
}

variable "nfs_path" {
  description = "NFS path"
  type        = string
}

variable "gitea_values" {
  description = "Path to the Gitea values file"
  type        = string
}

variable "postgresql_values" {
  description = "Path to the PostgreSQL values file"
  type        = string
}

variable "argocd_values" {
  description = "Path to the ArgoCD values file"
  type        = string
}

variable "vault_values" {
  description = "Path to the Vault values file"
  type        = string
}

variable "nfs_provisioner_values" {
  description = "Path to the NFS provisioner values file"
  type        = string
}

variable "become_password" {
  description = "Password for privilege escalation"
  type        = string
  sensitive   = true
}

variable "vault_root_token" {
  description = "Vault root token"
  type        = string
}


variable "gitea_db_username" {
  description = "Gitea database username"
  type        = string
  sensitive   = true
}

variable "gitea_db_password" {
  description = "Gitea database password"
  type        = string
  sensitive   = true
}

variable "argocd_admin_password" {
  description = "ArgoCD admin password"
  type        = string
  sensitive   = true
}

variable "vault_admin_password" {
  description = "Vault admin password"
  type        = string
  sensitive   = true
}

variable "vault_encryption_key" {
  description = "Vault encryption key"
  type        = string
  sensitive   = true
}

variable "vault_unseal_keys_b64" {
  description = "Base64-encoded Vault unseal keys"
  type        = string
  sensitive   = true
}

variable "vault_unseal_keys_hex" {
  description = "Hex-encoded Vault unseal keys"
  type        = string
  sensitive   = true
}

variable "applications" {
  description = "List of applications to configure Vault mounts and policies."
  type        = list(string)
  default = [
    "gitea",
    "argocd",
    "grafana",
    "prometheus",
    "traefik",
    "jenkins",
    "drawio",
    "kubernetes_dashboard",
    "metallb",
    "falco",
    "wazuh",
    "crowdsec",
    "netbox",
    "authentik",
    "vault",
    "kubernetes-dashboard",
    "longhorn",
    "chainloop",
  ]
}

variable "beszel_key" {
  description = "Beszel public key"
  type        = string
  sensitive   = true
}

variable "truenas_host" {
  description = "TrueNAS host IP address"
  type        = string
  default     = "192.168.1.190"
}

variable "truenas_ssh_user" {
  description = "TrueNAS SSH user"
  type        = string
  default     = "root"
}

variable "gitea_repo_url" {
  description = "URL to the Gitea repository"
  type        = string
  default     = "http://gitea-http.gitea.svc.cluster.local:3000/jordan/k8s-monitor" # Adjust this URL as needed
}