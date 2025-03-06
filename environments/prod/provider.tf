provider "proxmox" {
  endpoint = var.proxmox_api_url
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure = true  # Set to false in production with proper certs
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  
  # Skip TLS verification (only if you're using self-signed certificates)
  pm_tls_insecure = true
}

provider "kubernetes" {
  config_path = "~/.kube/config"  # Path to your kubeconfig file
}

provider "kubectl" {
  config_path = "~/.kube/config"  # Path to your kubeconfig file
}
