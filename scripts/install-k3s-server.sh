#!/bin/bash

#Keep this - curl -fsSL https://raw.githubusercontent.com/mcconnellj/k3s-server/scripts/install-k3s.sh | sh -

# Ensure the script runs as root or with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

# Set environment variables
export HOME=/root
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/.local/bin

# Update system packages
sudo apt update && sudo apt upgrade -y

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

# Install k9s via Webi
curl -sS https://webinstall.dev/k9s | bash

# Persist the PATH change for future sessions
if ! grep -q "$HOME/.local/bin" $HOME/.bashrc; then
    echo "export PATH=\$PATH:$HOME/.local/bin" >> $HOME/.bashrc
fi
source $HOME/.bashrc