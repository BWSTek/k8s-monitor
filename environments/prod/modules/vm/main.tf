resource "proxmox_vm_qemu" "vm" {
  name        = var.hostname
  target_node = var.target_node
  vmid        = var.vmid
  
  # Clone from ubuntu-cloud template
  clone       = "ubuntu-cloud"
  full_clone  = true

  # Hardware configuration
  memory      = var.memory
  cores       = var.cores
  sockets     = var.sockets
  cpu_type    = "host"
  scsihw      = var.scsihw
  
  # Boot configuration
  boot        = "order=ide2;scsi0"
  bootdisk    = "scsi0"
  
  # Agent and startup configuration
  agent       = 1
  onboot      = var.onboot
  vm_state    = var.vm_state

  # Serial console configuration
  vga {
    type = var.vga
  }

  # Storage configuration
  disks {
    ide {
      ide3 {
        cloudinit {
          storage = var.storage_pool
        }
      }
      ide2 {
        cdrom {
          iso = "isos:iso/talos-proxmox-nocloud-amd64.iso"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size            = var.disk_size
          storage         = var.storage_pool
          cache           = var.disk_cache
          iothread        = var.disk_iothread
          discard         = var.disk_discard
        }
      }
    }
  }

  # Network configuration
  network {
    id      = "1"
    model   = var.network_model
    bridge  = var.network_bridge
    tag     = var.network_tag
  }

  # Cloud-init configuration
  os_type    = "cloud-init"
  ciuser     = var.ciuser
  cipassword = var.cipassword
  ipconfig0  = var.ipconfig
  sshkeys    = var.ssh_public_keys
}
