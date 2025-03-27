#!/bin/bash

# Keep this curl -L -o k3s-server.zip "https://raw.githubusercontent.com/mcconnellj/k3s-server/scripts/install-k3s.sh?nocache=$(date +%s)" | sh -

# Update system packages
apt update
apt upgrade -y

# Download k3s manifests
curl -L -o k3s-server.zip "https://github.com/mcconnellj/k3s-server/archive/refs/heads/main.zip?nocache=$(date +%s)"
python3 -m zipfile -e k3s-server.zip .
rm k3s-server.zip

mkdir -p /var/lib/rancher/k3s/server/manifests/
mkdir -p /etc/rancher/k3s/
mv ./k3s-server-main/manifests/* /var/lib/rancher/k3s/server/manifests/
mv ./k3s-server-main/configs/k3s/* /etc/rancher/k3s/

# Install K3s
curl -sfL https://get.k3s.io | sh -

# Verify installations and output results
echo "Verifying installations..."

# Check if K3s is installed
if command -v k3s &> /dev/null; then
    echo "K3s installation: SUCCESS"
else
    echo "K3s installation: FAILED"
fi

# Check if k9s is installed
if command -v k9s &> /dev/null; then
    echo "k9s installation: SUCCESS"
else
    echo "k9s installation: FAILED"
fi

# Check if manifests were moved
if [[ -d /var/lib/rancher/k3s/server/manifests && "$(ls -A /var/lib/rancher/k3s/server/manifests)" ]]; then
    echo "Manifests move: SUCCESS"
else
    echo "Manifests move: FAILED"
fi

# Check if configs were moved
if [[ -d /etc/rancher/k3s && "$(ls -A /etc/rancher/k3s)" ]]; then
    echo "Configs move: SUCCESS"
else
    echo "Configs move: FAILED"
fi

