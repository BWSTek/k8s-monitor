# k8s-monitor

## Kubernetes Monitoring with Beszel, Grafana, and Prometheus

### Overview

This repository contains the necessary configuration to deploy [Beszel](https://github.com/henrygd/beszel), a lightweight monitoring solution, in a Kubernetes cluster. The setup includes:

1. A Beszel server running in Kubernetes
2. Direct monitoring of the Proxmox host where Kubernetes is running
3. Optional Kubernetes agent deployment (disabled by default)
4. Grafana
5. Prometheus

### Prerequisites

- A running Kubernetes cluster
- ArgoCD installed in the cluster
- Terraform with kubectl provider
- SSH access to your Proxmox host

### Deployment Steps

#### 1. Deploy the Beszel Server

```bash
# Apply the Terraform configuration
terraform apply
```

This will create:
- The ArgoCD application for Beszel
- The LoadBalancer service for external access

#### 2. Access the Beszel UI

Once deployed, access the Beszel UI at:
- http://beszel.{DOMAIN_NAME} (if DNS is configured)
- http://[LOADBALANCER_IP] (direct IP access)

#### 3. Complete Initial Setup

- Create an account in the Beszel UI
- Navigate to "Add system" to get the public key for agent installation

#### 4. Monitor Proxmox Host

Add your Proxmox host public key to terraform.tfvars:

```hcl
beszel_key = "YOUR_PUBLIC_KEY_FROM_BESZEL_UI"
```

Then apply:

```bash
terraform apply
```

This will install the Beszel agent on your Proxmox host and register it with your Beszel server.

### Configuration Options

#### Enable Kubernetes Agents

By default, Kubernetes agents are disabled. To enable them:

```yaml
# filepath: /environments/prod/charts/beszel/values.yaml
agent:
    enabled: true
```

#### Customize Persistent Storage

```yaml
# filepath: /environments/prod/charts/beszel/values.yaml
server:
    persistence:
        enabled: true
        storageClassName: "nfs-client"
        size: 5Gi
```

### Troubleshooting

#### Agent Not Connecting

If agents don't appear in the UI:
- Check firewall settings on the host
- Verify the agent is running: `systemctl status beszel-agent`
- Check agent logs: `journalctl -u beszel-agent`

#### ArgoCD Resources Stuck

If resources are stuck in "Progressing" state:
- Check the logs: `kubectl logs -n monitoring [pod-name]`
- Delete problematic resources: `kubectl delete daemonset beszel-agent -n monitoring`
- Ensure agent is disabled in values.yaml if not using Kubernetes agents

#### Duplicate Resources

If you see "Repeated Resource" warnings in ArgoCD:
- Ensure resources are only defined in one place (either Helm chart or direct kubectl_manifest)
- Use the `local.beszel_application_only = true` flag to only deploy the ArgoCD application

### Architecture

- **Beszel Server**: Runs in Kubernetes, provides the UI and data storage
- **Proxmox Agent**: Runs directly on the Proxmox host, provides accurate host metrics
- **Kubernetes Agents** (optional): Run as a DaemonSet, provide container metrics

### Maintenance

- **Agent updates**: Beszel agents can be configured to auto-update
- **Server updates**: Update the version in values.yaml and apply