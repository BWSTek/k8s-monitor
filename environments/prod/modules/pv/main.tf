resource "kubernetes_persistent_volume" "nfs_pv_gitea_postgresql" {
  metadata {
    name = "pv-gitea-postgresql"
    labels = {
      app  = "gitea"
      type = "postgresql"
    }
  }
  spec {
    capacity = {
      storage = "500Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "nfs"
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = "${var.nfs_path}/gitea/bitnami/postgresql"
      }
    }
  }
  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
  }
}



resource "kubernetes_persistent_volume" "nfs_pv_gitea_shared" {
  metadata {
    name = "pv-gitea-shared-storage"
    labels = {
      app = "gitea"
      type = "shared-storage"
    }
  }
  spec {
    capacity = {
      storage = "50Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "nfs"
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = "${var.nfs_path}/gitea/data"
      }
    }
  }
  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
  }
}

resource "kubernetes_persistent_volume" "nfs_pv_vault_0" {
  metadata {
    name = "pv-vault"
    labels = {
      app = "vault"
      type = "vault-data"
      volume = "0"
    }
  }
  spec {
    capacity = {
      storage = "100Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "nfs"
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = "${var.nfs_path}/vault/data"
      }
    }
  }
  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
  }
}

resource "kubernetes_persistent_volume" "nfs_pv_vault_audit_0" {
  metadata {
    name = "pv-vault-audit"
    labels = {
      app = "vault"
      type = "vault-audit"
      volume = "0"
    }
  }
  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "nfs"
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = "${var.nfs_path}/vault/audit"
      }
    }
  }
}
