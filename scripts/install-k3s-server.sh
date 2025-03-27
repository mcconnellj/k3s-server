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