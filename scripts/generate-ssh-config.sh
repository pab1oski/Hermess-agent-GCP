#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "${SCRIPT_DIR}")"

VM_IP=$(cd "${REPO_ROOT}/terraform" && terraform output -raw vm_ip)

SSH_BLOCK="Host hermes-agent
    HostName ${VM_IP}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
    StrictHostKeyChecking no"

SSH_DIR="${HOME}/.ssh"
SSH_CONFIG="${SSH_DIR}/config"

mkdir -p "${SSH_DIR}"
chmod 700 "${SSH_DIR}"

if [ ! -f "${SSH_CONFIG}" ]; then
    touch "${SSH_CONFIG}"
    chmod 600 "${SSH_CONFIG}"
fi

if grep -q "^Host hermes-agent$" "${SSH_CONFIG}" 2>/dev/null; then
    TMP_FILE=$(mktemp)
    # Copy every line except the existing hermes-agent block.
    # The block starts at "Host hermes-agent" and ends just before the next
    # "Host " line or EOF — so we track an in-block flag.
    in_block=0
    while IFS= read -r line || [ -n "${line}" ]; do
        if [ "${line}" = "Host hermes-agent" ]; then
            in_block=1
            continue
        fi
        if [ "${in_block}" -eq 1 ]; then
            # A new "Host " line (but not a continuation) ends the old block.
            if echo "${line}" | grep -qE "^Host "; then
                in_block=0
            else
                continue
            fi
        fi
        printf '%s\n' "${line}" >> "${TMP_FILE}"
    done < "${SSH_CONFIG}"
    # Strip trailing blank lines, then append the new block.
    printf '%s\n' "${SSH_BLOCK}" >> "${TMP_FILE}"
    mv "${TMP_FILE}" "${SSH_CONFIG}"
    chmod 600 "${SSH_CONFIG}"
else
    printf '\n%s\n' "${SSH_BLOCK}" >> "${SSH_CONFIG}"
fi

echo "SSH config updated. Connect with: ssh hermes-agent"
