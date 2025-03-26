#!/bin/bash

#Keep this - curl -fsSL https://raw.githubusercontent.com/mcconnellj/k3s-server/scripts/install-k3s.sh | sh -
#!/bin/bash

# Ensure the script runs as root
export HOME=/root

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

# Ensure the correct PATH is set for k9s **immediately**
export PATH=$PATH:/root/.local/bin

# Persist the PATH change for future sessions
echo 'export PATH=$PATH:/root/.local/bin' >> /root/.bashrc