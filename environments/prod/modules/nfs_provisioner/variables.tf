variable "nfs_server" {
  description = "NFS server address"
  type        = string
}

variable "nfs_path" {
  description = "NFS path"
  type        = string
}

variable "namespace" {
  description = "Namespace for the NFS provisioner"
  type        = string
}

variable "values" {
  description = "Values file for the Helm release"
  type        = string
}