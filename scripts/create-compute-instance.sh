#!/bin/bash

# Run this script curl -sSL https://raw.githubusercontent.com/mcconnellj/k3s-server/main/scripts/create-compute-instance.sh | bash

# Load environment variables from the .env file if needed
source .env

# Create the VM with dynamic variables
gcloud compute instances create k3s-cloud-tunnel-$(date +"%Y%m%d-%H%M%S") \
  --project="$GCP_PROJECT" \
  --zone="$ZONE" \
  --machine-type="$MACHINE_TYPE" \
  --network-interface=network-tier=STANDARD,stack-type=IPV4_ONLY,subnet=default \
  --maintenance-policy=TERMINATE \
  --provisioning-model=SPOT \
  --service-account="$SERVICE_ACCOUNT" \
  --scopes="$GCP_SCOPES" \
  --tags=http-server,https-server \
  --create-disk=auto-delete=yes,boot=yes,device-name=k3s-cloud-tunnel,image="$DISK_IMAGE",mode=rw,size="$DISK_SIZE",type="$DISK_TYPE" \
  --no-shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --labels="$LABELS" \
  --reservation-affinity=any \
  --metadata=startup-script-url="$STARTUP_SCRIPT_URL",ssh-keys="josh_v_mcconnell:$SSH_KEY" \
  --on-host-maintenance=TERMINATE \
  --automatic-restart=false \
  --local-ssd-recovery-timeout=0

# Create ops-agent policy configuration
printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml

# Apply ops-agent policy without the --resource-policies argument
gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-us-central1-a \
  --project="$GCP_PROJECT"
