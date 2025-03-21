#!/bin/bash

# Load environment variables from the .env file if needed
source .env

# Create the VM with dynamic variables
gcloud compute instances create k3s-cloud-tunnel-$(date +"%Y%m%d-%H%M%S") \
    --project="$GCP_PROJECT" \
    --zone="$ZONE" \
    --machine-type="$MACHINE_TYPE" \
    --network-interface=network-tier=STANDARD,stack-type=IPV4_ONLY,subnet=default \
    --metadata=enable-osconfig=TRUE,ssh-keys=josh_v_mcconnell:$SSH_KEY \
    --maintenance-policy=MIGRATE \
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
    --metadata=startup-script-url="$STARTUP_SCRIPT_URL" \
&& \
printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml \
&& \
gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-us-central1-a \
    --project="$GCP_PROJECT" \
    --zone="$ZONE" \
    --file=config.yaml \
&& \
gcloud compute resource-policies create snapshot-schedule "$SNAPSHOT_POLICY" \
    --project="$GCP_PROJECT" \
    --region=us-central1 \
    --max-retention-days=14 \
    --on-source-disk-delete=keep-auto-snapshots \
    --daily-schedule \
    --start-time=18:00 \
&& \
gcloud compute disks add-resource-policies k3s-cloud-tunnel \
    --project="$GCP_PROJECT" \
    --zone="$ZONE" \
    --resource-policies=projects/"$GCP_PROJECT"/regions/us-central1/resourcePolicies/"$SNAPSHOT_POLICY"
