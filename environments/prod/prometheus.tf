# Generate random values for prometheus OAuth integration
resource "random_string" "prometheus_client_id" {
  length  = 24
  special = false
}

resource "random_password" "prometheus_client_secret" {
  length  = 32
  special = true
}

# Create a Kubernetes secret with prometheus OAuth credentials
resource "kubernetes_secret" "prometheus_oauth_credentials" {
  metadata {
    name      = "prometheus-oauth-credentials"
    namespace = "prometheus"
  }

  data = {
    client_id     = random_string.prometheus_client_id.result
    client_secret = random_password.prometheus_client_secret.result
  }
}

# Output the credentials to use in the Authentik UI
output "prometheus_client_id" {
  value = random_string.prometheus_client_id.result
  sensitive = false
}

output "prometheus_client_secret" {
  value = random_password.prometheus_client_secret.result
  sensitive = true
}