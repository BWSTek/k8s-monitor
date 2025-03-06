# prox-cicd/terraform/modules/lxc/main.tf

resource "proxmox_lxc" "container" {
  hostname      = var.hostname
  target_node   = var.target_node
  vmid          = var.vmid
  ostemplate    = var.ostemplate
  ostype        = var.ostype
  memory        = var.memory
  password      = var.root_password
  cores         = var.cores
  unprivileged  = var.unprivileged
  start         = var.start
  onboot        = var.onboot
  swap          = var.swap
  tty           = var.tty
  protection    = var.protection

  ssh_public_keys = var.ssh_public_keys

  rootfs {
    storage = var.rootfs_storage
    size    = var.disk_size
  }

  features {
    fuse    = var.features_fuse
    keyctl  = var.features_keyctl
    mknod   = var.features_mknod
    nesting = var.features_nesting
  }

  network {
    bridge = var.network_bridge
    gw     = var.gateway_ip
    ip     = var.ip
    name   = var.network_name
    tag    = var.network_tag
    type   = var.network_type
  }
}