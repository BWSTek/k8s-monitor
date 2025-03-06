resource "helm_release" "leantime" {
  name       = "leantime"
  namespace  = var.leantime_namespace
  repository = var.repository["leantime"]
  chart      = "leantime"
  values     = [file(var.values["leantime"])]
}

resource "helm_release" "openproject" {
  name       = "openproject"
  namespace  = var.openproject_namespace
  repository = var.repository["openproject"]
  chart      = "openproject"
  values     = [file(var.values["openproject"])]
}

resource "helm_release" "vikunja" {
  name       = "vikunja"
  namespace  = var.vikunja_namespace
  repository = var.repository["vikunja"]
  chart      = "vikunja"
  values     = [file(var.values["vikunja"])]
}