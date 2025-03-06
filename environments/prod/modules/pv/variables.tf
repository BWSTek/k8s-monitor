variable "nfs_server" {
  description = "NFS server address"
  type        = string
}

variable "nfs_path" {
  description = "NFS path"
  type        = string
}

variable "gitea_namespace" {
  description = "Namespace for Gitea"
  type        = string
}

variable "vault_namespace" {
  description = "Namespace for Vault"
  type        = string
}