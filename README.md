# Hermes Agent on GCP

Deploy an autonomous AI Software Engineer on Google Cloud Platform using [Hermes Agent](https://hermes-agent.nousresearch.com/) (Nous Research). The agent listens for GitHub Issues via webhook, clones your repos, implements changes, runs tests, and opens Pull Requests — all without human intervention.

## Architecture

```
GitHub Issue
     ↓ webhook (port 8644)
  Hermes Agent (VM)
     ↓ OpenAI-compatible API
  LiteLLM proxy (localhost:4000)
     ↓ Vertex AI SDK
  Gemini 2.5 Pro / Flash
     ↓ git push + gh pr create
  GitHub Pull Request + Issue comment
```

**Infrastructure:** GCP e2-standard-2 VM · Debian 12 · us-central1 · Secret Manager for credentials

## Quick Start

### Prerequisites

- [gcloud CLI](https://cloud.google.com/sdk/docs/install) installed and authenticated (`gcloud auth login`)
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- [gh CLI](https://cli.github.com) installed and authenticated (`gh auth login`)
- [shellcheck](https://www.shellcheck.net) installed (`apt install shellcheck` / `brew install shellcheck`)
- A GCP project with billing enabled
- A GitHub Fine-Grained PAT with `contents:write` and `pull-requests:write` scopes
- A webhook secret — any random string, e.g. `openssl rand -hex 32`
- A LiteLLM master key — any random string, e.g. `openssl rand -hex 32`

### 1. Bootstrap Terraform state

```bash
# Creates GCS bucket for Terraform state + enables required GCP APIs
./scripts/bootstrap-tfstate.sh <your-gcp-project-id>
```

After this completes, edit `terraform/backend.tf` and replace the placeholder on line 14:

```
bucket = "REPLACE_WITH_PROJECT_ID-tfstate"
```

with your actual bucket name (e.g. `my-project-123-tfstate`).

### 2. Configure variables

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

Edit `terraform.tfvars`. Required variables:

| Variable | Description |
|----------|-------------|
| `project_id` | Your GCP project ID |
| `repo_url` | URL of **this** repo — the VM clones it to get `config/`, `scripts/`, and `skills/` (e.g. `https://github.com/your-org/Hermess-agent-GCP`) |

Optional variables (have defaults):

| Variable | Default | Description |
|----------|---------|-------------|
| `agent_name` | `hermess-agent` | Name prefix for all GCP resources |
| `region` | `us-central1` | GCP region |
| `zone` | `us-central1-a` | GCP zone |
| `machine_type` | `e2-standard-2` | VM machine type |
| `disk_size_gb` | `50` | Boot disk size |
| `ssh_allowed_cidr` | `0.0.0.0/0` | CIDR for SSH firewall — restrict to your IP for security |

### 3. Deploy infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

This creates: VM, Service Account, static IP, firewall rules (SSH + webhook port 8644), and 3 empty Secret Manager secrets.

### 4. Populate secrets

Secret names use the `agent_name` prefix (default `hermess-agent`). Replace `<project-id>` and values accordingly:

```bash
echo -n "your-github-pat" | \
  gcloud secrets versions add hermess-agent-github-pat --data-file=- --project=<project-id>

echo -n "your-webhook-secret" | \
  gcloud secrets versions add hermess-agent-github-webhook-secret --data-file=- --project=<project-id>

echo -n "sk-$(openssl rand -hex 32)" | \
  gcloud secrets versions add hermess-agent-litellm-master-key --data-file=- --project=<project-id>
```

> **Note:** The secrets must be populated BEFORE rebooting the VM or re-running startup.sh, because the startup script reads them at boot time.

### 5. Wait for VM provisioning (~3-5 min)

The VM automatically runs `scripts/startup.sh` → `scripts/provision.sh` on first boot. This installs Docker, GitHub CLI, Hermes Agent, LiteLLM, and copies all config and skills.

To check provisioning status (this also registers your SSH key on the VM — required for `ssh hermes-agent` to work later):

```bash
gcloud compute ssh hermess-agent-vm --zone=us-central1-a -- \
  "sudo journalctl -u google-startup-scripts -n 50 --no-pager"
```

### 6. Configure GitHub webhook

On your target GitHub repo: **Settings → Webhooks → Add webhook**

- Payload URL: `http://<vm-ip>:8644/webhook`
  - Get the IP: `cd terraform && terraform output -raw vm_ip`
- Content type: `application/json`
- Secret: (same value you set for `hermess-agent-github-webhook-secret`)
- Events: select **Issues**

Then SSH into the VM and activate the webhook gateway:

```bash
gcloud compute ssh hermess-agent-vm --zone=us-central1-a
# Once inside the VM:
bash /opt/hermes-deploy/scripts/setup-webhook.sh
exit
```

### 7. Verify everything works

```bash
# From your local machine (requires terraform state initialized)
./scripts/test-e2e.sh
```

Expected output:
```
[PASS] SSH conecta
[PASS] hermes instalado
[PASS] LiteLLM activo
[PASS] modelo gemini-2.5-pro
[PASS] skill git-workflow
[PASS] gateway activo
[PASS] gh autenticado

Resultado: 7/7 checks passed
```

For deeper validation (inference, HMAC, branch naming):

```bash
./scripts/test-e2e-full.sh
```

### 8. Test the end-to-end flow

Create a test issue on any repository the agent has access to. Within ~30 seconds:

1. The gateway receives the webhook and triggers the agent.
2. The agent clones the repo and creates branch `{agent_name}/issue-{number}/{slug}`.
3. The agent implements the requested changes and opens a Pull Request.
4. A comment with the PR link appears on the original issue.

You can monitor the agent in real time:

```bash
gcloud compute ssh hermess-agent-vm --zone=us-central1-a -- \
  "sudo -u hermess journalctl -u hermes -f"
```

## Repository Structure

```
.
├── terraform/             # IaC — VM, SA, firewall, Secret Manager
├── scripts/               # startup.sh, provision.sh, test-e2e.sh
├── config/
│   ├── hermes/            # config.yaml, SOUL.md (agent identity)
│   ├── litellm/           # LiteLLM proxy config (Vertex AI routing)
│   └── systemd/           # litellm.service, hermes-gateway.service
├── skills/
│   └── git-workflow/      # Custom skill: clone → branch → PR → comment
├── specs/                 # Feature specs (requirements, design, tasks)
├── docs/                  # Architecture, conventions, verification guide
└── AGENTS.md              # Entry point for AI agents working on this repo
```

## Connecting with Cursor / VSCode

See [docs/cursor-ssh-guide.md](docs/cursor-ssh-guide.md) for step-by-step instructions to connect via Remote SSH and manage skills, config, and workspaces live.

## Customization

| What | Where |
|---|---|
| Agent name and personality | `config/hermes/SOUL.md` |
| Model routing (Pro/Flash) | `config/litellm/config.yaml` |
| Git workflow (branch naming, PR template) | `skills/git-workflow/SKILL.md` |
| VM size, region, disk | `terraform/terraform.tfvars` |
| SSH access CIDR | `terraform/terraform.tfvars` → `ssh_allowed_cidr` |

## Adding Skills and MCPs

```bash
# From Cursor connected via SSH, or directly on the VM:
hermes skills install <skill-id>          # from official registry
hermes skills install ./skills/my-skill   # from local path
hermes mcp install <mcp-name>             # MCP server
```

Custom skills go in `skills/` — they're installed automatically by `provision.sh`.

## How it works (for AI agents)

See `AGENTS.md` for the agent orchestration model used to build and maintain this repo.
