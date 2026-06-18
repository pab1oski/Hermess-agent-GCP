#!/usr/bin/env bash
set -euo pipefail

METADATA_BASE="http://metadata.google.internal/computeMetadata/v1/instance/attributes"
METADATA_HEADER="Metadata-Flavor: Google"

AGENT_NAME="$(curl -sf -H "${METADATA_HEADER}" "${METADATA_BASE}/agent-name")"
REPO_URL="$(curl -sf -H "${METADATA_HEADER}" "${METADATA_BASE}/repo-url")"
DEPLOY_USER="hermess"
HERMES_HOME="/home/${DEPLOY_USER}/.hermes"

echo "[startup] agent=${AGENT_NAME} repo=${REPO_URL} user=${DEPLOY_USER}"

# --- System dependencies ---

echo "[startup] Installing system packages"
apt-get update -qq
apt-get install -y git python3.11 python3-pip python3-venv curl \
  apt-transport-https ca-certificates gnupg

# --- Docker ---

if ! command -v docker &>/dev/null; then
  echo "[startup] Installing Docker"
  curl -fsSL https://get.docker.com | sh
  usermod -aG docker "${DEPLOY_USER}" || true
else
  echo "[startup] Docker already installed"
fi

# --- GitHub CLI ---

if ! command -v gh &>/dev/null; then
  echo "[startup] Installing GitHub CLI"
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list
  apt-get update -qq
  apt-get install -y gh
else
  echo "[startup] GitHub CLI already installed"
fi

# --- Deploy user ---

if ! id "${DEPLOY_USER}" &>/dev/null; then
  echo "[startup] Creating user ${DEPLOY_USER}"
  useradd -m -s /bin/bash "${DEPLOY_USER}"
fi

# --- Python packages ---

echo "[startup] Installing pip packages"
pip3 install --upgrade --break-system-packages hermes-agent "litellm[proxy]"

# --- Secrets ---

echo "[startup] Fetching secrets from Secret Manager"
mkdir -p "${HERMES_HOME}"
GITHUB_TOKEN="$(gcloud secrets versions access latest --secret="${AGENT_NAME}-github-pat")"
GITHUB_WEBHOOK_SECRET="$(gcloud secrets versions access latest --secret="${AGENT_NAME}-github-webhook-secret")"
PROJECT_ID="$(curl -sf -H "${METADATA_HEADER}" "http://metadata.google.internal/computeMetadata/v1/project/project-id")"
LITELLM_MASTER_KEY="$(gcloud secrets versions access latest --secret="${AGENT_NAME}-litellm-master-key")"

cat > "${HERMES_HOME}/.env" <<EOF
GITHUB_TOKEN=${GITHUB_TOKEN}
GITHUB_WEBHOOK_SECRET=${GITHUB_WEBHOOK_SECRET}
GOOGLE_CLOUD_PROJECT=${PROJECT_ID}
LITELLM_MASTER_KEY=${LITELLM_MASTER_KEY}
EOF
chmod 600 "${HERMES_HOME}/.env"
echo "[startup] Secrets written to ${HERMES_HOME}/.env"

# --- Clone or update repo ---

if [ ! -d /opt/hermes-deploy ]; then
  echo "[startup] Cloning repo"
  git clone "https://${GITHUB_TOKEN}@${REPO_URL#https://}" /opt/hermes-deploy
else
  echo "[startup] Pulling latest changes"
  git -C /opt/hermes-deploy pull
fi

# --- LiteLLM systemd service ---

echo "[startup] Installing litellm.service"
cp /opt/hermes-deploy/config/systemd/litellm.service /etc/systemd/system/litellm.service
systemctl daemon-reload
systemctl enable litellm
echo "[startup] LiteLLM service installed (will start after provision)"

# --- Hermes Gateway systemd service ---

echo "[startup] Installing hermes-gateway.service"
cp /opt/hermes-deploy/config/systemd/hermes-gateway.service /etc/systemd/system/hermes-gateway.service
systemctl daemon-reload
echo "[startup] Hermes Gateway service installed (will be enabled by setup-webhook.sh)"

# --- Provision ---

echo "[startup] Running provision.sh"
bash /opt/hermes-deploy/scripts/provision.sh

# --- Start LiteLLM (config now in place) ---

echo "[startup] Starting LiteLLM"
systemctl start litellm
echo "[startup] LiteLLM started"

echo "[startup] Done"
