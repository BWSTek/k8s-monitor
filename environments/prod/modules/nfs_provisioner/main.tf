resource "helm_release" "nfs_provisioner" {
  name       = "nfs-subdir-external-provisioner"
  namespace  = var.namespace
  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
  chart      = "nfs-subdir-external-provisioner"
  values     = [file(var.values)]
}