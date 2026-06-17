#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${1:-}"

if [[ -z "$PROJECT_ID" ]]; then
  echo "Usage: $0 <project_id>" >&2
  exit 1
fi

BUCKET_NAME="${PROJECT_ID}-tfstate"
REGION="${2:-us-central1}"

echo "Enabling required GCP APIs..."
gcloud services enable \
  compute.googleapis.com \
  secretmanager.googleapis.com \
  aiplatform.googleapis.com \
  --project="$PROJECT_ID"

echo "Creating GCS bucket for Terraform state: gs://${BUCKET_NAME}"
if gsutil ls -b "gs://${BUCKET_NAME}" &>/dev/null; then
  echo "Bucket gs://${BUCKET_NAME} already exists, skipping creation."
else
  gsutil mb -p "$PROJECT_ID" -l "$REGION" -b on "gs://${BUCKET_NAME}"
  echo "Bucket gs://${BUCKET_NAME} created."
fi

echo "Enabling versioning on gs://${BUCKET_NAME}..."
gsutil versioning set on "gs://${BUCKET_NAME}"

echo ""
echo "Bootstrap complete."
echo "Before running 'terraform init', update terraform/backend.tf:"
echo "  bucket = \"${BUCKET_NAME}\""
