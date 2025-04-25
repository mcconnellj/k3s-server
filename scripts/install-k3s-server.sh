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
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -s

# Setup Kube Config
sudo chmod 600 /etc/rancher/k3s/k3s.yaml
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> $HOME/.bashrc
source $HOME/.bashrc

# Install K9s
curl -L -o k9s_linux_amd64.deb https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb
sudo apt install ./k9s_linux_amd64.deb
rm k9s_linux_amd64.deb

#kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/applicationset/master/manifests/install.yaml
#kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/crds/appproject-crd.yaml
