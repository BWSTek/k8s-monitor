# Generate random values for grafana OAuth integration
resource "random_string" "grafana_client_id" {
  length  = 24
  special = false
}

resource "random_password" "grafana_client_secret" {
  length  = 32
  special = true
}

# Update the kubernetes_secret resource

resource "kubernetes_secret" "grafana_oauth_credentials" {
  metadata {
    name      = "grafana-oauth-credentials"
    namespace = "monitoring"  # Change to match your Grafana namespace
  }

  data = {
    client_id     = random_string.grafana_client_id.result
    client_secret = random_password.grafana_client_secret.result
  }
}

# # Create the grafana-alert-rules ConfigMap
# resource "kubernetes_config_map" "grafana_alert_rules" {
#   metadata {
#     name      = "grafana-alert-rules"
#     namespace = "monitoring"
#   }

#   # Load the alert rules from your YAML file
#   data = {
#     "alertrules.yaml" = file("${path.module}/manifests/grafana-alert-rules.yaml")
#   }
# }

# # Create the grafana-playlists ConfigMap
# resource "kubernetes_config_map" "grafana_playlists" {
#   metadata {
#     name      = "grafana-playlists"
#     namespace = "monitoring"
#   }

#   data = {
#     "playlists.yaml" = jsonencode({
#       apiVersion = 1
#       playlists = [
#         {
#           name     = "System Overview"
#           interval = "5m"
#           items = [
#             { type = "dashboard_by_tag", value = "system" },
#             { type = "dashboard_by_tag", value = "kubernetes" }
#           ]
#         },
#         {
#           name     = "Error Detection"
#           interval = "2m"
#           items = [
#             { type = "dashboard_by_tag", value = "errors" },
#             { type = "dashboard_by_tag", value = "logs" }
#           ]
#         }
#       ]
#     })
#   }
# }

