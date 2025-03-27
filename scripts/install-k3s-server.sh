#!/bin/bash

# Keep this curl -L -o k3s-server.zip "https://raw.githubusercontent.com/mcconnellj/k3s-server/scripts/install-k3s.sh?nocache=$(date +%s)" | sh -

# Update system packages
apt update
apt upgrade -y

# Install k9s globally
curl -sS https://webinstall.dev/k9s | bash
if [[ -f /root/.local/bin/k9s ]]; then
    mv /root/.local/bin/k9s /usr/local/bin/k9s
    chmod +x /usr/local/bin/k9s
fi

# Create necessary directories
mkdir -p /var/lib/rancher/k3s/server/manifests/
mkdir -p /var/lib/rancher/k3s/

# Download k3s manifests
curl -L -o k3s-server.zip "https://github.com/mcconnellj/k3s-server/archive/refs/heads/main.zip?nocache=$(date +%s)"
python3 -m zipfile -e k3s-server.zip .
rm k3s-server.zip

# Move manifests and config files
mv ./k3s-server-main/manifests/ /etc/rancher/k3s/server/manifests/
mv ./k3s-server-main/config/k3s/ /var/lib/rancher/k3s/

# Install K3s
curl -sfL https://get.k3s.io | sh -