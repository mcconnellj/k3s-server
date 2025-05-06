#!/bin/bash

# Keep this curl -L -o k3s-server.zip "https://raw.githubusercontent.com/mcconnellj/k3s-server/scripts/install-k3s.sh?nocache=$(date +%s)" | sh -

# Update system packages
apt update
apt upgrade -y

# Download k3s manifests
curl -L -o k3s-server.zip "https://github.com/mcconnellj/k3s-server/archive/refs/heads/development.zip?nocache=$(date +%s)"
python3 -m zipfile -e k3s-server.zip .
rm k3s-server.zip

# Get the current machine's IP
export NODE_IP=$(ip -4 addr show ens18 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Create or update the K3s config file dynamically
cat <<EOF > ./k3s-server-development/configs/cloud-development.yaml
node-ip: ${NODE_IP}
advertise-address: ${NODE_IP}
tls-san:
  - ${NODE_IP}
EOF

mkdir -p /var/lib/rancher/k3s/server/manifests/
mkdir -p /etc/rancher/k3s/
mv ./k3s-server-development/manifests/k3s-init/* /var/lib/rancher/k3s/server/manifests/


# Install K3s with the configuration file.
curl -sfL https://get.k3s.io | K3S_TOKEN=$SETUP_CLUSTERTOKEN \
  K3S_CONFIG_FILE=./k3s-server-development/configs/cloud-development.yaml \
  sh -s -

# Setup Kube Config
sudo chmod 600 /etc/rancher/k3s/k3s.yaml
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> $HOME/.bashrc
source $HOME/.bashrc

# Helm install Cilium
helm repo add cilium https://helm.cilium.io
helm repo update
helm install cilium cilium/cilium -n kube-system \
  -f applications-core/cilium/values.yaml \
  -f applications-core/cilium/development.yaml \
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
