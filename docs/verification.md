# Verification — End-to-End Deployment Checklist

Run these steps in order after any deploy or change. Each step must pass before
moving to the next.

---

## Step 1 — Terraform Validation (before deploy)

```bash
cd terraform
terraform validate
terraform plan
```

Expected: `terraform validate` prints `Success!`. `terraform plan` shows the VM,
Service Account, static IP, 2 firewall rules, and 2 Secret Manager secrets.

---

## Step 2 — Deploy

```bash
cd terraform
terraform apply
```

Wait for the VM to boot and run the startup script (~3 min). You can monitor
progress in the GCP console under **Compute Engine → VM instances → Serial port**.

---

## Step 3 — Smoke Tests (8 checks via SSH)

```bash
./scripts/test-e2e.sh
```

Checks performed:
1. SSH connection to the VM
2. `hermes --version` returns a version string
3. LiteLLM health endpoint (`localhost:4000/health`) returns 200
4. `gemini-2.5-pro` appears in the LiteLLM config
5. Vertex AI inference — a real request reaches Gemini and returns a response
6. `git-workflow` skill is installed (`hermes skills list`)
7. Hermes Gateway is active (`hermes gateway status`)
8. `gh` CLI is authenticated

All 8 must report `PASS`.

---

## Step 4 — Extended Tests (3 deeper checks)

```bash
./scripts/test-e2e-full.sh
```

Checks performed:
1. `gemini-2.5-flash` inference — fast model responds correctly
2. Invalid HMAC webhook → gateway returns `401 Unauthorized`
3. Branch naming format matches `{agent_name}/issue-{number}/{slug}`

All 3 must report `PASS`.

---

## Step 5 — Manual Webhook Test

Create a test issue in your target GitHub repository. Within ~30 seconds:

1. The Gateway receives the webhook (visible in `journalctl -u hermes-gateway -f` on the VM).
2. The Agent clones the repo and creates branch `{agent_name}/issue-{number}/{slug}`.
3. The Agent implements the requested changes and runs tests.
4. A Pull Request is opened with the changes.
5. A comment is posted on the original issue with the PR link.

---

## Service Diagnostics (on the VM)

Use these when a check fails to identify the root cause.

```bash
# LiteLLM proxy
sudo systemctl status litellm
journalctl -u litellm -n 50

# Hermes Agent
sudo systemctl status hermes
journalctl -u hermes -n 50

# Hermes Gateway
sudo -u hermess hermes gateway status
journalctl -u hermes-gateway -n 50

# Verify LiteLLM responds locally
curl -s http://localhost:4000/health

# Verify gh CLI auth
sudo -u hermess gh auth status
```

---

## Quick Re-verify After a Change

```bash
# Re-run smoke tests only (no deploy)
./scripts/test-e2e.sh

# Validate Terraform without deploying
cd terraform && terraform validate && terraform plan
```
