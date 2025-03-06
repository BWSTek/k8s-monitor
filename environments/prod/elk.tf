# resource "kubectl_manifest" "elastic" {
#   yaml_body = <<-YAML
# apiVersion: argoproj.io/v1alpha1
# kind: Application
# metadata:
#   name: elastic-stack
#   namespace: argocd
# spec:
#   project: monitor-project
#   source:
#     repoURL: https://helm.elastic.co
#     targetRevision: 7.17.3
#     chart: elasticsearch
#     helm:
#       values: |
#         replicas: 1
#         minimumMasterNodes: 1
#         resources:
#           requests:
#             cpu: "500m"
#             memory: "1Gi"
#           limits:
#             cpu: "1000m"
#             memory: "2Gi"
#         persistence:
#           enabled: true
#           size: 20Gi
#   destination:
#     server: https://kubernetes.default.svc
#     namespace: monitoring
#   syncPolicy:
#     automated:
#       prune: true
#       selfHeal: true
# YAML
# }

# resource "kubectl_manifest" "kibana" {
#   depends_on = [kubectl_manifest.elastic]
#   yaml_body = <<-YAML
# apiVersion: argoproj.io/v1alpha1
# kind: Application
# metadata:
#   name: kibana
#   namespace: argocd
# spec:
#   project: monitor-project
#   source:
#     repoURL: https://helm.elastic.co
#     targetRevision: 7.17.3
#     chart: kibana
#     helm:
#       values: |
#         elasticsearchHosts: "http://elasticsearch-master.monitoring.svc.cluster.local:9200"
#         ingress:
#           enabled: true
#           hosts:
#             - kibana.{DOMAIN_NAME}
#   destination:
#     server: https://kubernetes.default.svc
#     namespace: monitoring
#   syncPolicy:
#     automated:
#       prune: true
#       selfHeal: true
# YAML
# }