# Extract the hostname from the API URL
locals {
  proxmox_host = replace(replace(var.proxmox_api_url, "https://", ""), ":8006/api2/json", "")
  beszel_application_only = true
}

# Install Beszel agent on the Proxmox host
resource "null_resource" "proxmox_beszel_agent" {
  connection {
    type        = "ssh"
    user        = "root"
    host        = local.proxmox_host
    private_key = file(replace(var.ssh_public_key, ".pub", ""))
    timeout     = "2m"
  }
  
  # First check connectivity and write the key to a file
  provisioner "remote-exec" {
    inline = [
      "echo 'SSH connection successful to ${local.proxmox_host}'",
      "echo 'Creating temporary key file...'",
      "echo '${var.beszel_key}' > /tmp/beszel_key.txt",
      "chmod 600 /tmp/beszel_key.txt"
    ]
  }

  # Run the installation separately with auto-answer for prompts
  provisioner "remote-exec" {
    inline = [
      "curl -sL https://raw.githubusercontent.com/henrygd/beszel/main/supplemental/scripts/install-agent.sh -o /tmp/install-agent.sh",
      "chmod +x /tmp/install-agent.sh",
      "echo 'Running Beszel agent installation (with automatic updates enabled)...'",
      "echo y | /tmp/install-agent.sh -k \"$(cat /tmp/beszel_key.txt)\" -p 45876 || echo 'Installation failed with code $?'",
      "rm -f /tmp/beszel_key.txt",
      "echo 'Installation complete'"
    ]
  }
}

resource "null_resource" "add_beszel_system" {
  depends_on = [null_resource.proxmox_beszel_agent]

  provisioner "local-exec" {
    command = <<-EOT
      curl -X POST "http://{IP_ADDRESS}/api/systems" \
      -H "Content-Type: application/json" \
      -d '{
        "name": "Proxmox Host",
        "host": "{PROXMOX_IP_ADDRESS}",
        "port": 45876,
        "key": "${var.beszel_key}"
      }'
    EOT
  }
}
