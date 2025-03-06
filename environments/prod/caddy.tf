# Create direct LoadBalancer service for grafana
resource "kubectl_manifest" "grafana_direct" {
  yaml_body = file("${path.module}/caddy/grafana-direct.yaml")
}

# Create direct LoadBalancer service for prometheus
resource "kubectl_manifest" "prometheus_direct" {
  yaml_body = file("${path.module}/caddy/prometheus-direct.yaml")
}

# Your existing ingress resources can stay if needed
resource "kubectl_manifest" "grafana_ingress" {
  yaml_body = file("${path.module}/caddy/grafana-ingress.yaml")
}

resource "kubectl_manifest" "prometheus_ingress" {
  yaml_body = file("${path.module}/caddy/prometheus-ingress.yaml")
}

resource "kubectl_manifest" "prometheus_basic_auth" {
  yaml_body = file("${path.module}/caddy/prometheus-basic-auth.yaml")
}

resource "kubectl_manifest" "beszel_direct" {
  yaml_body = file("${path.module}/caddy/beszel-direct.yaml")
}