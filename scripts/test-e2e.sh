#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# E2E smoke tests — runs 8 checks against the live Hermes agent VM.
# Usage: ./scripts/test-e2e.sh
# ---------------------------------------------------------------------------

PASS=0
FAIL=0
TOTAL=8

# Resolve VM coordinates from Terraform state
VM_NAME=$(cd terraform && terraform output -raw vm_name 2>/dev/null) || {
  echo "ERROR: could not read vm_name from terraform output." >&2
  echo "       Run 'terraform apply' first or check that state is initialized." >&2
  exit 1
}

VM_ZONE=$(cd terraform && terraform output -raw vm_zone 2>/dev/null) || {
  echo "ERROR: could not read vm_zone from terraform output." >&2
  exit 1
}

PROJECT=$(cd terraform && terraform output -raw project_id 2>/dev/null) || {
  echo "ERROR: could not read project_id from terraform output." >&2
  exit 1
}

# check LABEL COMMAND
# Runs COMMAND via SSH on the VM and records pass/fail.
check() {
  local label="${1}"
  local cmd="${2}"
  if gcloud compute ssh "${VM_NAME}" \
        --zone="${VM_ZONE}" \
        --project="${PROJECT}" \
        --no-tunnel-through-iap \
        --command="${cmd}" \
        -- -q 2>/dev/null; then
    echo "[PASS] ${label}"
    PASS=$(( PASS + 1 ))
  else
    echo "[FAIL] ${label}"
    FAIL=$(( FAIL + 1 ))
  fi
}

# --- checks ---
check "SSH conecta"           "true"
check "hermes instalado"      "hermes --version"
check "LiteLLM activo"        "curl -sf http://localhost:4000/health/liveliness"
check "modelo gemini-2.5-pro" "grep -q 'gemini-2.5-pro' /etc/litellm/config.yaml"
check "inferencia Vertex AI"  "curl -sf -X POST http://localhost:4000/v1/chat/completions -H 'Content-Type: application/json' -d '{\"model\":\"gemini-2.5-flash\",\"messages\":[{\"role\":\"user\",\"content\":\"say: ok\"}],\"max_tokens\":5}' | grep -q 'choices'"
check "skill git-workflow"    "ls /home/hermess/.hermes/skills/ | grep -q git-workflow"
check "gateway activo"        "sudo -u hermess hermes gateway status | grep -q active"
check "gh autenticado"        "sudo -u hermess bash -c 'source /home/hermess/.hermes/.env && GH_TOKEN=\$GITHUB_TOKEN gh auth status'"

# --- summary ---
echo ""
echo "Resultado: ${PASS}/${TOTAL} checks passed"

[[ "${FAIL}" -eq 0 ]]
