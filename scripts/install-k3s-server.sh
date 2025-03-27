#!/bin/bash

# Keep this - curl -fsSL https://raw.githubusercontent.com/mcconnellj/k3s-server/scripts/install-k3s.sh | sh -

# Update system packages
sudo apt update && sudo apt upgrade -y
sudo apt install k9s -y

# Create necessary directories
mkdir -p /var/lib/rancher/k3s/server/manifests/

# Download k3s manifests
curl -L -o k3s-server.zip https://github.com/mcconnellj/k3s-server/archive/refs/heads/main.zip
python3 -m zipfile -e k3s-server.zip .
rm k3s-server.zip

# Move manifests and config files
mv ./manifests/* /etc/rancher/k3s/server/manifests/
mv ./config/k3s/* /var/lib/rancher/k3s/

# Install K3s
curl -sfL https://get.k3s.io | sh -