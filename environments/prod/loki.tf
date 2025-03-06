resource "kubectl_manifest" "loki" {
  yaml_body = <<-YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: loki-stack
  namespace: argocd
spec:
  project: monitor-project
  source:
    repoURL: ${var.gitea_repo_url}
    targetRevision: HEAD
    path: environments/prod/charts/loki-stack
  destination:
    server: https://kubernetes.default.svc
    namespace: monitoring
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
YAML
}

# Add Loki datasource to existing Grafana
resource "kubectl_manifest" "loki_datasource" {
  depends_on = [kubectl_manifest.loki]
  yaml_body = <<-YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-loki-datasource
  namespace: monitoring
  labels:
    grafana_datasource: "1"
data:
  loki-datasource.yaml: |
    apiVersion: 1
    datasources:
    - name: Loki
      type: loki
      uid: loki
      url: http://loki-stack:3100
      access: proxy
      isDefault: false
      editable: true
YAML
}

# ServiceMonitor CRD for Prometheus Operator
resource "kubectl_manifest" "service_monitor_crd" {
  yaml_body = <<-YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: servicemonitors.monitoring.coreos.com
spec:
  group: monitoring.coreos.com
  names:
    kind: ServiceMonitor
    listKind: ServiceMonitorList
    plural: servicemonitors
    singular: servicemonitor
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              endpoints:
                type: array
                items:
                  type: object
                  properties:
                    port:
                      # This is the correct way to define int-or-string in K8s CRDs
                      x-kubernetes-int-or-string: true
                    path:
                      type: string
                    scheme:
                      type: string
                    interval:
                      type: string
                    scrapeTimeout:
                      type: string
                    bearerTokenFile:
                      type: string
                    bearerTokenSecret:
                      type: object
                      required:
                      - key
                      properties:
                        key:
                          type: string
                        name:
                          type: string
                        optional:
                          type: boolean
                    honorLabels:
                      type: boolean
                    honorTimestamps:
                      type: boolean
                    metricRelabelings:
                      type: array
                      items:
                        type: object
                        properties:
                          action:
                            type: string
                          modulus:
                            type: integer
                            format: int64
                          regex:
                            type: string
                          replacement:
                            type: string
                          separator:
                            type: string
                          sourceLabels:
                            type: array
                            items:
                              type: string
                          targetLabel:
                            type: string
              selector:
                type: object
                properties:
                  matchLabels:
                    type: object
                    additionalProperties:
                      type: string
                  matchExpressions:
                    type: array
                    items:
                      type: object
                      required:
                      - key
                      - operator
                      properties:
                        key:
                          type: string
                        operator:
                          type: string
                        values:
                          type: array
                          items:
                            type: string
              namespaceSelector:
                type: object
                properties:
                  any:
                    type: boolean
                  matchNames:
                    type: array
                    items:
                      type: string
              targetLabels:
                type: array
                items:
                  type: string
              podTargetLabels:
                type: array
                items:
                  type: string
              jobLabel:
                type: string
              sampleLimit:
                type: integer
                format: int64
YAML
}

# Create a direct service to access Loki from outside the cluster
resource "kubectl_manifest" "loki_direct" {
  depends_on = [kubectl_manifest.loki]
  yaml_body = <<-YAML
apiVersion: v1
kind: Service
metadata:
  name: loki-direct
  namespace: monitoring
spec:
  # These match your actual pod labels from the kubectl output
  selector:
    app: loki
    name: loki-stack
  ports:
    - port: 80
      targetPort: 3100
      protocol: TCP
  type: LoadBalancer
YAML
}

# Generate a secure password for Loki basic auth
resource "random_password" "loki_password" {
  length  = 16
  special = false
}

# Create basic auth secret
resource "kubectl_manifest" "loki_basic_auth" {
  yaml_body = <<-YAML
apiVersion: v1
kind: Secret
metadata:
  name: loki-basic-auth
  namespace: monitoring
type: Opaque
data:
  auth: ${base64encode("admin:${random_password.loki_password.result}")}
YAML
}

# Create an Ingress for Loki UI
resource "kubectl_manifest" "loki_ingress" {
  depends_on = [kubectl_manifest.loki_direct, kubectl_manifest.loki_basic_auth]
  yaml_body = <<-YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: loki-ingress
  namespace: monitoring
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    # Add basic auth annotation
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: loki-basic-auth
    nginx.ingress.kubernetes.io/auth-realm: "Authentication Required"
spec:
  rules:
  - host: loki.{DOMAIN_NAME}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            # Option 1: Use our direct service
            name: loki-direct
            port:
              number: 80
            # Option 2: Use the Helm-created service (use this if Option 1 doesn't work)
            # name: loki-stack
            # port:
            #   number: 3100
  tls:
  - hosts:
    - loki.{DOMAIN_NAME}
    secretName: loki-tls
YAML
}