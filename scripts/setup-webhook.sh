#!/usr/bin/env bash
set -euo pipefail

DEPLOY_USER="hermess"

# The webhook secret is read by the gateway from EnvironmentFile at service start.
# No manual secret registration needed.

WEBHOOK_SECRET="$(grep '^WEBHOOK_SECRET=' "/home/${DEPLOY_USER}/.hermes/.env" | cut -d= -f2)"

echo "[setup-webhook] Subscribing to GitHub issues with skill git-workflow"
sudo -u "${DEPLOY_USER}" hermes webhook subscribe github \
  --events issues \
  --skills git-workflow \
  --secret "${WEBHOOK_SECRET}" \
  --description "Handle GitHub issues: clone repo, implement, open PR" \
  --prompt 'A GitHub issue has been opened. You must resolve it following your workflow in SOUL.md.

Repository: {repository.full_name}
Clone URL: {repository.clone_url}
Issue number: {issue.number}
Issue title: {issue.title}
Issue URL: {issue.html_url}

Issue body:
{issue.body}

Follow your full workflow: clone the repo, create a branch named $AGENT_NAME/issue-{issue.number}/<slug>, implement the fix, write tests, commit, open a PR, and comment on the issue with the PR link.'

echo "[setup-webhook] Enabling hermes-gateway service"
systemctl enable --now hermes-gateway

echo "[setup-webhook] Done. Run 'hermes gateway status' to verify."
