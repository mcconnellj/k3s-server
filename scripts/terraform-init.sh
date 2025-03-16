#!/bin/bash

# Control-plane
# wget -qO- https://example.com/install-k3s.sh | bash -s server

# Worker-only node
# wget -qO- https://example.com/install-k3s.sh | bash -s worker --token <token> --server https://<server-ip>:6443

# Install Terraform
sudo apt-get update && sudo apt-get install -y unzip wget git
TERRAFORM_VERSION="1.6.6"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -install-autocomplete

git clone https://github.com/YOUR_USERNAME/YOUR_K3S_REPO.git
cd YOUR_K3S_REPO
