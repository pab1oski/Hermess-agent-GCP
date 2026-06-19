#!/usr/bin/env bash
set -euo pipefail

DEPLOY_USER="hermess"
ENV_FILE="/home/${DEPLOY_USER}/.hermes/.env"

# Source .env if GITHUB_WEBHOOK_SECRET is not already in the environment
if [ -z "${GITHUB_WEBHOOK_SECRET:-}" ]; then
  if [ -f "${ENV_FILE}" ]; then
    # shellcheck source=/dev/null
    source "${ENV_FILE}"
  fi
fi

if [ -z "${GITHUB_WEBHOOK_SECRET:-}" ]; then
  echo "[setup-webhook] ERROR: GITHUB_WEBHOOK_SECRET is not set and not found in ${ENV_FILE}" >&2
  exit 1
fi

echo "[setup-webhook] Configuring webhook secret"
sudo -u "${DEPLOY_USER}" hermes webhook secret set "${GITHUB_WEBHOOK_SECRET}"

echo "[setup-webhook] Subscribing to issues.opened with skill git-workflow"
sudo -u "${DEPLOY_USER}" hermes webhook subscribe issues.opened --skill git-workflow

echo "[setup-webhook] Enabling hermes-gateway service"
systemctl enable --now hermes-gateway

echo "[setup-webhook] Done. Run 'hermes gateway status' to verify."
