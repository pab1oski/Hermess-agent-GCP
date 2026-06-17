#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# E2E extended tests — 3 deeper checks against the live Hermes agent VM.
# Usage: ./scripts/test-e2e-full.sh
# ---------------------------------------------------------------------------

PASS=0
FAIL=0
TOTAL=3

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

check "inference gemini-2.5-flash" \
  "curl -sf http://localhost:4000/v1/chat/completions \
    -H 'Content-Type: application/json' \
    -d '{\"model\":\"gemini-2.5-flash\",\"messages\":[{\"role\":\"user\",\"content\":\"ping\"}],\"max_tokens\":5}' \
  | grep -q 'choices'"

check "HMAC invalido → 401" \
  "curl -sf -o /dev/null -w '%{http_code}' \
    -X POST http://localhost:8644/webhook \
    -H 'X-Hub-Signature-256: sha256=invalid' \
    -H 'Content-Type: application/json' \
    -d '{}' \
  | grep -q '^401\$'"

check "branch naming format" \
  "AGENT_NAME=\$(grep agent_name ~/.hermes/config.yaml | awk '{print \$2}') && \
   BRANCH=\"\${AGENT_NAME}/issue-0/test-branch\" && \
   git -C /tmp init test-branch-check 2>/dev/null && \
   git -C /tmp/test-branch-check checkout -b \"\${BRANCH}\" 2>/dev/null && \
   echo \"\${BRANCH}\" | grep -qE '^[a-z0-9_-]+/issue-[0-9]+/[a-z0-9_-]+\$' && \
   rm -rf /tmp/test-branch-check"

# --- summary ---
echo ""
echo "Resultado: ${PASS}/${TOTAL} checks passed"

[[ "${FAIL}" -eq 0 ]]
