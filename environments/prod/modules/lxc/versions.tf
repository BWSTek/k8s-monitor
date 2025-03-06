# prox-cicd/terraform/modules/lxc/versions.tf

terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"  # Must match or be compatible with the root module's provider version
    }
  }
}