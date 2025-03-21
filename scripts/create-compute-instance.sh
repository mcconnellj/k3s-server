#!/bin/bash

# Run this script curl -sSL https://raw.githubusercontent.com/mcconnellj/k3s-server/main/scripts/create-compute-instance.sh | bash

# Load environment variables from the .env file if needed
source .env

# Create the VM with dynamic variables
gcloud compute instances create $INSTANCE_NAME \
    --project=$GCP_PROJECT \
    --zone=$GCP_ZONE \
    --machine-type=$MACHINE_TYPE \
    --network-interface=network-tier=$NETWORK_TIER,stack-type=IPV4_ONLY,subnet=$SUBNET \
    --maintenance-policy=MIGRATE \
    --provisioning-model=SPOT \
    --service-account=$SERVICE_ACCOUNT \
    --scopes=$SCOPES \
    --create-disk=auto-delete=yes,boot=yes,device-name=$INSTANCE_NAME,disk-resource-policy=projects/$GCP_PROJECT/regions/us-central1/resourcePolicies/default-schedule-1,image=$DISK_IMAGE,mode=rw,size=$DISK_SIZE,type=$DISK_TYPE \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=$LABELS \
    --reservation-affinity=any \
    $(if [ "$PREEMPTIBLE" = true ]; then echo "--preemptible"; fi)
