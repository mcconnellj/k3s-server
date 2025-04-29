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

# Get the current machines ip
export SETUP_NODEIP=$(ip -4 addr show ens18 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Install K3s with the configuration file.
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.32.2+k3s1" \
  INSTALL_K3S_EXEC="--node-ip=192.168.0.47 --advertise-address=192.168.0.47 --tls-san 192.168.0.47" \
  K3S_TOKEN=$SETUP_CLUSTERTOKEN \
  K3S_CONFIG_FILE=./config.yaml \
  sh -s -

# Setup Kube Config
mkdir -p $HOME/.kube
sudo cp -i /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
chmod 600 $HOME/.kube/config

# Helm install Cilium
helm repo add cilium https://helm.cilium.io
helm repo update
helm install cilium cilium/cilium -n kube-system \
  -f applications/cilium/values.yaml \
  -f applications/cilium/development.yaml \
  --version 1.17.0-rc.2 \
  --set operator.replicas=1

# Install K9s
curl -L -o k9s_linux_amd64.deb https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb
sudo apt install ./k9s_linux_amd64.deb
rm k9s_linux_amd64.deb

# Wait for Argo CD
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# Get initial password (change immediately!)
ARGO_PASS=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)
echo "Argo CD Password: $ARGO_PASS"




#kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/applicationset/master/manifests/install.yaml
#kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/crds/appproject-crd.yaml
