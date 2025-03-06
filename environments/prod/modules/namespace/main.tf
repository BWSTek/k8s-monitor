resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
    labels = {
      "argocd.argoproj.io/instance" = "namespaces"
    }
  }
}

resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
    labels = {
      "argocd.argoproj.io/instance" = "namespaces"
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit" = "privileged"
      "pod-security.kubernetes.io/warn" = "privileged"
    }
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      "argocd.argoproj.io/instance" = "namespaces"
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit" = "privileged"
      "pod-security.kubernetes.io/warn" = "privileged"
    }
  }
}
