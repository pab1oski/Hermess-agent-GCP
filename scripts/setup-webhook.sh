#!/usr/bin/env bash
set -euo pipefail

DEPLOY_USER="hermess"

# The webhook secret is read by the gateway from EnvironmentFile at service start.
# No manual secret registration needed.

echo "[setup-webhook] Subscribing to issues.opened with skill git-workflow"
sudo -u "${DEPLOY_USER}" hermes webhook subscribe issues.opened --skill git-workflow

echo "[setup-webhook] Enabling hermes-gateway service"
systemctl enable --now hermes-gateway

echo "[setup-webhook] Done. Run 'hermes gateway status' to verify."
