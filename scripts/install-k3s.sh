#!/bin/bash

set -e

#curl -fsSL https://raw.githubusercontent.com/mcconnellj/k3s-server/scripts/install-k3s.sh | sh -

# Set variables
CONFIG_URL="https://raw.githubusercontent.com/mcconnellj/k3s-server/config/k3s/config.yaml"
CONFIG_DIR="/etc/rancher/k3s"
CONFIG_FILE="${CONFIG_DIR}/config.yaml"

echo "[+] Creating config directory if it doesn't exist"
sudo mkdir -p "$CONFIG_DIR"

echo "[+] Downloading K3s config file from $CONFIG_URL"
sudo wget -qO "$CONFIG_FILE" "$CONFIG_URL"

echo "[+] Installing K3s with the downloaded config file"
curl -sfL https://get.k3s.io | sh -

echo "[+] K3s installation complete!"
