#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEPLOY_USER="${SUDO_USER:-$USER}"
HERMES_HOME="/home/${DEPLOY_USER}/.hermes"

echo "[provision] repo=${REPO_DIR} user=${DEPLOY_USER} home=${HERMES_HOME}"

# --- Hermes home directories ---

mkdir -p "${HERMES_HOME}/skills"

# --- Hermes config files ---

if [ -d "${REPO_DIR}/config/hermes" ]; then
  cp -r "${REPO_DIR}/config/hermes/." "${HERMES_HOME}/"
  echo "[provision] Copied config/hermes/ to ${HERMES_HOME}/"
fi

# --- Skills ---

for skill_dir in "${REPO_DIR}/skills"/*/; do
  skill_name="$(basename "${skill_dir}")"
  if [ -f "${skill_dir}SKILL.md" ]; then
    mkdir -p "${HERMES_HOME}/skills/${skill_name}"
    cp "${skill_dir}SKILL.md" "${HERMES_HOME}/skills/${skill_name}/SKILL.md"
    echo "[provision] Installed skill: ${skill_name}"
  fi
done

# --- LiteLLM config ---

mkdir -p /etc/litellm
cp "${REPO_DIR}/config/litellm/config.yaml" /etc/litellm/config.yaml
echo "[provision] Copied litellm config to /etc/litellm/config.yaml"

# --- Ownership ---

chown -R "${DEPLOY_USER}:${DEPLOY_USER}" "${HERMES_HOME}"
echo "[provision] Done"
