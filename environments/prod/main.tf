module "namespace" {
  source = "./modules/namespace/"
}

# Apply monitor-project.yaml
resource "kubectl_manifest" "monitor_project" {
  yaml_body = file("${path.module}/apps/monitor-project.yaml")
}

# # Apply leantime.yaml
# resource "kubectl_manifest" "leantime" {
#   yaml_body = file("${path.module}/apps/leantime.yaml")
#   depends_on = [module.namespace.leantime_namespace]
# }

# Apply openproject.yaml
# resource "kubectl_manifest" "openproject" {
#   yaml_body = file("${path.module}/apps/openproject.yaml")
#   depends_on = [module.namespace.openproject_namespace]
# }

# Apply grafana.yaml
resource "kubectl_manifest" "grafana" {
  yaml_body = file("${path.module}/apps/grafana.yaml")
  depends_on = [module.namespace.grafana_namespace]
}

resource "kubectl_manifest" "prometheus" {
  yaml_body = file("${path.module}/apps/prometheus.yaml")
  depends_on = [module.namespace.prometheus_namespace]
}

resource "kubectl_manifest" "beszel" {
  yaml_body = file("${path.module}/apps/beszel.yaml")
}
