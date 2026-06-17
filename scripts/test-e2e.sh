#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# E2E smoke tests — runs 7 checks against the live Hermes agent VM.
# Usage: ./scripts/test-e2e.sh
# ---------------------------------------------------------------------------

PASS=0
FAIL=0
TOTAL=7

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

# check LABEL COMMAND
# Runs COMMAND via SSH on the VM and records pass/fail.
check() {
  local label="${1}"
  local cmd="${2}"
  if gcloud compute ssh "${VM_NAME}" \
        --zone="${VM_ZONE}" \
        --tunnel-through-iap=false \
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
check "SSH conecta"          "true"
check "hermes instalado"     "hermes --version"
check "LiteLLM activo"       "curl -sf http://localhost:4000/health"
check "modelo gemini-2.5-pro" "curl -sf http://localhost:4000/v1/models | grep -q gemini-2.5-pro"
check "skill git-workflow"   "hermes skills list | grep -q git-workflow"
check "gateway activo"       "hermes gateway status | grep -q active"
check "gh autenticado"       "gh auth status"

# --- summary ---
echo ""
echo "Resultado: ${PASS}/${TOTAL} checks passed"

[[ "${FAIL}" -eq 0 ]]
