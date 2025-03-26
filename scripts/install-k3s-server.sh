#!/bin/bash

# Keep this - curl -fsSL https://raw.githubusercontent.com/mcconnellj/k3s-server/scripts/install-k3s.sh | sh -

# Ensure the script runs as root or with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

# Create user josh_v_mcconnell if it doesn't exist
if ! id -u "josh_v_mcconnell" &>/dev/null; then
    echo "Creating user josh_v_mcconnell..."
    useradd -m -s /bin/bash josh_v_mcconnell
else
    echo "User josh_v_mcconnell already exists."
fi

# Set environment variables for root
export HOME=/root
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/.local/bin:/root/.local/bin

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

# Switch to the user josh_v_mcconnell and install k9s
echo "Switching to user josh_v_mcconnell to install k9s..."

sudo -u josh_v_mcconnell bash -c 'curl -sS https://webinstall.dev/k9s | bash'

# Source .bashrc for the user josh_v_mcconnell
sudo -u josh_v_mcconnell bash -c 'source $HOME/.bashrc'

# Inform user that installation is complete
echo "K9s has been installed for user josh_v_mcconnell."