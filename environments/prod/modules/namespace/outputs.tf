output "grafana_namespace" {
  value = kubernetes_namespace.grafana.metadata[0].name
}

output "prometheus_namespace" {
  value = kubernetes_namespace.prometheus.metadata[0].name
}
