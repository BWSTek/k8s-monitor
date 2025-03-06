resource "kubernetes_storage_class" "nfs" {
  metadata {
    name = "nfs"
    annotations = {
      "meta.helm.sh/release-name"      = "nfs-provisioner"
      "meta.helm.sh/release-namespace" = "storage"
    }
    labels = {
      app                          = "nfs-subdir-external-provisioner"
      "app.kubernetes.io/managed-by" = "Helm"
      chart                        = "nfs-subdir-external-provisioner-4.0.18"
      heritage                     = "Helm"
      release                      = "nfs-provisioner"
    }
  }
  storage_provisioner = "nfs-subdir-external-provisioner"
  parameters = {
    path   = "${var.nfs_path}/"
    server = var.nfs_server
  }
  reclaim_policy         = "Delete"
  volume_binding_mode    = "Immediate"
  allow_volume_expansion = true
  lifecycle {
    ignore_changes = [
      parameters["archiveOnDelete"],
      metadata[0].annotations,
      metadata[0].labels,
    ]
  }
}