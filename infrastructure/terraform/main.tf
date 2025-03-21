# =====================================================================
# Purpose:
# This Terraform configuration automates the installation of K3s on a
# set of servers and worker nodes. It uses a `null_resource` to execute
# remote provisioning commands for setting up K3s on each node.
#
# =====================================================================
# Sections:
# 1. Host Configuration: Define the list of hosts with boolean flags for server or worker.
# 2. K3s Install Commands: Define the installation commands for servers and workers.
# 3. Resource Configuration: Use `null_resource` to install K3s on the servers and workers.
# 4. Error Handling: Ensure proper error handling during installation.
# =====================================================================

# Example Comment Block to Guide AI
# =====================================================================
# Begin defining the host information below:
# - Each host has an IP address and a boolean indicating whether it is a server or worker.
# - Modify the IP addresses as needed, and adjust the boolean value accordingly.
# - Servers will use the 'server_install_command', while workers will use the 'worker_install_command'.
# - This configuration allows for flexible management of nodes based on their roles.
# =====================================================================

provider "null" {}

# =====================================================================
# K3s Install Commands:
# This section defines the two installation commands that will be used:
# - One command for servers to join the K3s cluster and set up the server components.
# - Another command for workers to join the cluster and register as worker nodes.
# =====================================================================
variable "k3s_token" {
  type        = string
  description = "Shared K3s token for the cluster"
}

variable "etcd_url" {
  type        = string
  default     = "https://10.0.0.1:6443"
}

locals {
  # Command for server nodes
  server_install_command = "curl -sfL https://get.k3s.io | sh -s - server --server ${var.etcd_url} --token ${var.k3s_token} --disable-etcd"

  # Command for worker nodes
  worker_install_command = "curl -sfL https://get.k3s.io | K3S_URL=${var.etcd_url} K3S_TOKEN=${var.k3s_token} sh -"
}

# =====================================================================
# Resource Configuration:
# This section uses a `null_resource` to install K3s on the hosts defined 
# in the `hosts` variable. It uses the `is_server` flag to determine 
# which installation command to run for each host.
# =====================================================================
resource "null_resource" "k3s_install" {
  for_each = var.hosts

  # Connect to the host using SSH
  connection {
    host        = each.value.ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }

  # Provisioning logic: Install dependencies and K3s based on the host role
  provisioner "remote-exec" {
    inline = [
      "echo Installing dependencies...",
      "sudo apt-get update && sudo apt-get install -y curl",
      
      # Use the appropriate install command based on whether the host is a server or worker
      each.value.is_server ? local.server_install_command : local.worker_install_command,

      # Error handling for failed installation
      "if [ $? -ne 0 ]; then echo 'Error occurred during installation on ${each.key}' && exit 1; fi"
    ]
  }

  # Ensure resources run in the correct order if necessary (e.g., servers before workers)
  depends_on = []
}

# =====================================================================
# Error Handling:
# This section handles any potential errors during the installation process.
# If the installation fails, an error message will be displayed indicating
# which host encountered the issue.
# =====================================================================
