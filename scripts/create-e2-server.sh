#!/bin/bash

# Run this script curl -sSL https://raw.githubusercontent.com/mcconnellj/k3s-server/main/scripts/create-e2-server.sh?nocache=$(date +%s) | bash

# Load environment variables from the .env file if needed
source .env

# Validate required environment variables
if [[ -z "$INSTANCE_NAME" || -z "$GCP_PROJECT" || -z "$GCP_ZONE" || -z "$MACHINE_TYPE" || -z "$SERVICE_ACCOUNT" || -z "$SCOPES" ]]; then
    echo "Error: One or more required environment variables are not set."
    echo "Please ensure the following variables are set in your .env file or environment:"
    echo "  INSTANCE_NAME, GCP_PROJECT, GCP_ZONE, MACHINE_TYPE, SERVICE_ACCOUNT, SCOPES"
    exit 1
fi

# Create the VM with dynamic variables
gcloud compute instances create $INSTANCE_NAME \
    --project=$GCP_PROJECT \
    --zone=$GCP_ZONE \
    --machine-type=$MACHINE_TYPE \
    --network-interface=network-tier=STANDARD,stack-type=IPV4_ONLY,subnet=default \
    --provisioning-model=SPOT \
    --instance-termination-action=STOP \
    --service-account=$SERVICE_ACCOUNT \
    --scopes=$SCOPES \
    --tags=http-server,https-server \
    --create-disk=auto-delete=yes,boot=yes,device-name=instance-20250321-180030,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20250313,mode=rw,size=10,type=pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any \
    --metadata=startup-script-url=https://raw.githubusercontent.com/mcconnellj/k3s-server/development/scripts/install-k3s-server.sh?nocache=$(date +%s)

