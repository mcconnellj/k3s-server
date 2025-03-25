#!/bin/bash

#curl -fsSL https://raw.githubusercontent.com/mcconnellj/k3s-server/scripts/install-k3s.sh | sh -

sudo apt update && sudo apt upgrade -y

mkdir -p /var/lib/rancher/k3s/server/manifests/

curl -L -o k3s-server.zip https://github.com/mcconnellj/k3s-server/archive/refs/heads/main.zip
unzip k3s-server.zip & rm k3s-server.zip

mv ./manifests/* /etc/rancher/k3s/server/manifests/
mv ./config/k3s/* /var/lib/rancher/k3s/

curl -sfL https://get.k3s.io | sh -
curl -sS https://webinstall.dev/k9s | bash

