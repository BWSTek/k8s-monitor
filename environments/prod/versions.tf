terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
  required_version = ">= 0.13"
}
