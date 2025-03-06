# TrueNAS SCALE Monitoring Integration

# resource "null_resource" "truenas_test" {
#   connection {
#     type        = "ssh"
#     user        = var.truenas_ssh_user
#     host        = var.truenas_host
#     private_key = file(replace(var.ssh_public_key, ".pub", ""))
#   }
  
#   provisioner "remote-exec" {
#     inline = ["echo 'Connection test successful'"]
#   }
# }

# # Install node exporter on TrueNAS
# resource "null_resource" "truenas_node_exporter" {
#   connection {
#     type        = "ssh"
#     user        = var.truenas_ssh_user
#     host        = var.truenas_host
#     private_key = file(replace(var.ssh_public_key, ".pub", ""))
#   }
  
#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Installing Node Exporter...'",
#       "wget -q https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz",
#       "tar xzf node_exporter-1.7.0.linux-amd64.tar.gz",
#       "cp node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/",
#       "chmod +x /usr/local/bin/node_exporter",
#       "rm -rf node_exporter-1.7.0.linux-amd64 node_exporter-1.7.0.linux-amd64.tar.gz",
#       "cat > /etc/systemd/system/node_exporter.service << 'EOL'",
#       "[Unit]",
#       "Description=Prometheus Node Exporter",
#       "After=network.target",
#       "",
#       "[Service]",
#       "Type=simple",
#       "ExecStart=/usr/local/bin/node_exporter",
#       "Restart=always",
#       "",
#       "[Install]",
#       "WantedBy=multi-user.target",
#       "EOL",
#       "systemctl daemon-reload",
#       "systemctl enable node_exporter",
#       "systemctl start node_exporter"
#     ]
#   }
# }

# # Install Beszel agent on TrueNAS
# resource "null_resource" "truenas_beszel_agent" {
#   depends_on = [null_resource.truenas_node_exporter]
  
#   connection {
#     type        = "ssh"
#     user        = var.truenas_ssh_user
#     host        = var.truenas_host
#     private_key = file(replace(var.ssh_public_key, ".pub", ""))
#   }
  
#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Installing Beszel agent...'",
#       "curl -sL https://raw.githubusercontent.com/henrygd/beszel/main/supplemental/scripts/install-agent.sh -o /tmp/install-agent.sh",
#       "chmod +x /tmp/install-agent.sh",
#       "echo y | /tmp/install-agent.sh -k \"${var.beszel_key}\" -p 45876"
#     ]
#   }
# }

# # Register TrueNAS in Beszel via API
# resource "null_resource" "truenas_beszel_registration" {
#   depends_on = [null_resource.truenas_beszel_agent]
  
#   provisioner "local-exec" {
#     command = <<-EOT
#       curl -X POST "http://192.168.4.248/api/systems" \
#       -H "Content-Type: application/json" \
#       -d '{
#         "name": "TrueNAS",
#         "host": "${var.truenas_host}",
#         "port": 45876,
#         "key": "${var.beszel_key}"
#       }'
#     EOT
#   }
# }

# # Add TrueNAS to Prometheus configuration
# resource "kubectl_manifest" "truenas_prometheus_config_map" {
#   yaml_body = <<-YAML
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: prometheus-truenas-scrape
#   namespace: monitoring
# data:
#   truenas.yml: |
#     - job_name: 'truenas'
#       scrape_interval: 15s
#       static_configs:
#         - targets: ['${var.truenas_host}:9100']
#       relabel_configs:
#         - source_labels: [__address__]
#           target_label: instance
#           replacement: 'truenas'
# YAML
# }

# # Deploy TrueNAS dashboard to Grafana
# resource "kubectl_manifest" "truenas_grafana_dashboard" {
#   yaml_body = <<-YAML
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: truenas-dashboard
#   namespace: monitoring
#   labels:
#     grafana_dashboard: "1"
# data:
#   truenas-dashboard.json: |
#     {
#       "annotations": {
#         "list": []
#       },
#       "editable": true,
#       "fiscalYearStartMonth": 0,
#       "graphTooltip": 0,
#       "links": [],
#       "liveNow": false,
#       "panels": [
#         {
#           "datasource": {
#             "type": "prometheus",
#             "uid": "PBFA97CFB590B2093"
#           },
#           "fieldConfig": {
#             "defaults": {
#               "color": {
#                 "mode": "palette-classic"
#               },
#               "custom": {
#                 "axisCenteredZero": false,
#                 "axisColorMode": "text",
#                 "axisLabel": "",
#                 "axisPlacement": "auto",
#                 "barAlignment": 0,
#                 "drawStyle": "line",
#                 "fillOpacity": 0.1,
#                 "gradientMode": "none",
#                 "hideFrom": {
#                   "legend": false,
#                   "tooltip": false,
#                   "viz": false
#                 },
#                 "lineInterpolation": "linear",
#                 "lineWidth": 1,
#                 "pointSize": 5,
#                 "scaleDistribution": {
#                   "type": "linear"
#                 },
#                 "showPoints": "auto",
#                 "spanNulls": false,
#                 "stacking": {
#                   "group": "A",
#                   "mode": "none"
#                 },
#                 "thresholdsStyle": {
#                   "mode": "off"
#                 }
#               },
#               "mappings": [],
#               "thresholds": {
#                 "mode": "absolute",
#                 "steps": [
#                   {
#                     "color": "green",
#                     "value": null
#                   },
#                   {
#                     "color": "red",
#                     "value": 80
#                   }
#                 ]
#               },
#               "unit": "percent"
#             },
#             "overrides": []
#           },
#           "gridPos": {
#             "h": 8,
#             "w": 12,
#             "x": 0,
#             "y": 0
#           },
#           "id": 1,
#           "options": {
#             "legend": {
#               "calcs": [],
#               "displayMode": "list",
#               "placement": "bottom",
#               "showLegend": true
#             },
#             "tooltip": {
#               "mode": "single",
#               "sort": "none"
#             }
#           },
#           "title": "CPU Usage",
#           "type": "timeseries",
#           "targets": [
#             {
#               "datasource": {
#                 "type": "prometheus",
#                 "uid": "PBFA97CFB590B2093"
#               },
#               "expr": "100 - (avg by (instance) (irate(node_cpu_seconds_total{mode=\"idle\",instance=\"truenas\"}[5m])) * 100)",
#               "refId": "A"
#             }
#           ]
#         },
#         {
#           "datasource": {
#             "type": "prometheus",
#             "uid": "PBFA97CFB590B2093"
#           },
#           "fieldConfig": {
#             "defaults": {
#               "color": {
#                 "mode": "palette-classic"
#               },
#               "custom": {
#                 "axisCenteredZero": false,
#                 "axisColorMode": "text",
#                 "axisLabel": "",
#                 "axisPlacement": "auto",
#                 "barAlignment": 0,
#                 "drawStyle": "line",
#                 "fillOpacity": 0.1,
#                 "gradientMode": "none",
#                 "hideFrom": {
#                   "legend": false,
#                   "tooltip": false,
#                   "viz": false
#                 },
#                 "lineInterpolation": "linear",
#                 "lineWidth": 1,
#                 "pointSize": 5,
#                 "scaleDistribution": {
#                   "type": "linear"
#                 },
#                 "showPoints": "auto",
#                 "spanNulls": false,
#                 "stacking": {
#                   "group": "A",
#                   "mode": "none"
#                 },
#                 "thresholdsStyle": {
#                   "mode": "off"
#                 }
#               },
#               "mappings": [],
#               "thresholds": {
#                 "mode": "absolute",
#                 "steps": [
#                   {
#                     "color": "green",
#                     "value": null
#                   },
#                   {
#                     "color": "red",
#                     "value": 80
#                   }
#                 ]
#               },
#               "unit": "bytes"
#             },
#             "overrides": []
#           },
#           "gridPos": {
#             "h": 8,
#             "w": 12,
#             "x": 12,
#             "y": 0
#           },
#           "id": 2,
#           "options": {
#             "legend": {
#               "calcs": [],
#               "displayMode": "list",
#               "placement": "bottom",
#               "showLegend": true
#             },
#             "tooltip": {
#               "mode": "single",
#               "sort": "none"
#             }
#           },
#           "title": "Memory Usage",
#           "type": "timeseries",
#           "targets": [
#             {
#               "datasource": {
#                 "type": "prometheus",
#                 "uid": "PBFA97CFB590B2093"
#               },
#               "expr": "node_memory_MemTotal_bytes{instance=\"truenas\"} - node_memory_MemFree_bytes{instance=\"truenas\"} - node_memory_Buffers_bytes{instance=\"truenas\"} - node_memory_Cached_bytes{instance=\"truenas\"}",
#               "refId": "A"
#             }
#           ]
#         }
#       ],
#       "refresh": "5s",
#       "schemaVersion": 38,
#       "style": "dark",
#       "tags": ["truenas"],
#       "title": "TrueNAS Monitoring",
#       "version": 1
#     }
# YAML
# }