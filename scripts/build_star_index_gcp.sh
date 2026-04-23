#!/bin/bash
# Build full GRCh38 STAR index on GCP
# Run once, saves index to GCS

# Create a VM
gcloud compute instances create star-index-builder \
    --zone=us-east1-b \
    --machine-type=n2-highmem-8 \
    --boot-disk-size=100GB \
    --boot-disk-type=pd-ssd \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --scopes=storage-full
echo "VM created. SSH in and run the index build commands."
echo "gcloud compute ssh star-index-builder --zone=us-central1-a"