#!/usr/bin/env bash
set -euo pipefail

if [ -z "${GITHUB_WEBHOOK_SECRET:-}" ]; then
  echo "[setup-webhook] ERROR: GITHUB_WEBHOOK_SECRET is not set" >&2
  exit 1
fi

echo "[setup-webhook] Configuring webhook secret"
hermes webhook secret set "${GITHUB_WEBHOOK_SECRET}"

echo "[setup-webhook] Subscribing to issues.opened with skill git-workflow"
hermes webhook subscribe issues.opened --skill git-workflow

echo "[setup-webhook] Enabling hermes-gateway service"
systemctl enable --now hermes-gateway

echo "[setup-webhook] Done. Run 'hermes gateway status' to verify."
