#!/bin/bash

#curl -fsSL https://raw.githubusercontent.com/mcconnellj/k3s-server/scripts/install-k3s.sh | sh -

sudo apt update && sudo apt upgrade -y

mkdir -p /var/lib/rancher/k3s/server/manifests/argocd
curl -o /var/lib/rancher/k3s/server/manifests/argocd.yaml https://raw.githubusercontent.com/mcconnellj/k3s-server/main/manifests/argocd/argocd.yaml
##curl -o /var/lib/rancher/k3s/server/manifests/phase-one-applicationset.yaml https://raw.githubusercontent.com/mcconnellj/k3s-server/main/manifests/phase-one-applicationset.yaml

curl -sfL https://get.k3s.io | sh -
