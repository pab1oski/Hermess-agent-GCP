# Architecture — Hermes Agent on GCP

## System Overview

Hermes Agent is an autonomous AI Software Engineer that listens for GitHub Issues,
implements the requested changes, and opens Pull Requests — without human intervention.

```
GitHub Issue
     │ webhook POST (port 8644)
     ▼
Hermes Gateway          ← receives and authenticates webhooks (HMAC)
     │ triggers agent with issue body
     ▼
Hermes Agent            ← AI Software Engineer (clone → branch → implement → test → PR)
     │ OpenAI-compatible API (localhost:4000)
     ▼
LiteLLM Proxy           ← local proxy, routes to Vertex AI
     │ Vertex AI SDK (europe-west1)
     ▼
Gemini 2.5 Pro/Flash    ← inference
     │ git push + gh pr create
     ▼
GitHub PR + Issue comment
```

---

## Layers

### GitHub Layer (trigger + output)

| Component      | Role                                                  |
|----------------|-------------------------------------------------------|
| Issues         | Trigger: each new issue fires a webhook to the VM     |
| Pull Requests  | Output: agent opens a PR with the implemented changes |
| Issue comments | Status: agent comments the PR link on the source issue|

### GCP Layer

| Resource              | Details                                                      |
|-----------------------|--------------------------------------------------------------|
| VM                    | `e2-standard-2`, Debian 12, zone `us-central1-a`            |
| Service Account       | Roles: `aiplatform.user` + `secretmanager.secretAccessor`    |
| Static IP             | Assigned to the VM; exposed on port 22 (SSH) and 8644 (webhook) |
| Firewall rules        | Allow TCP 22 (SSH) and TCP 8644 (webhook) from `0.0.0.0/0`  |
| Secret Manager        | `hermess-agent-gh-token` (GitHub PAT) + `hermess-agent-litellm-master-key` |

Terraform resource naming follows `{agent_name}-{resource_type}`:

```
hermess-vm   hermess-sa   hermess-ip   hermess-allow-ssh   hermess-allow-webhook
```

### VM Layer (services running inside the VM)

All services run as `systemd` units under the `hermess` OS user.

| Service         | Port           | Role                                                  |
|-----------------|----------------|-------------------------------------------------------|
| LiteLLM proxy   | `localhost:4000` | OpenAI-compatible proxy that routes to Vertex AI    |
| Hermes Agent    | —              | AI agent that reads issues and writes code            |
| Hermes Gateway  | `0.0.0.0:8644` | Receives GitHub webhooks and triggers the agent       |
| GitHub CLI (`gh`) | —            | Creates PRs and posts comments on issues              |

### Vertex AI Layer (inference)

| Detail         | Value                         |
|----------------|-------------------------------|
| Main model     | `gemini-2.5-pro`              |
| Fast model     | `gemini-2.5-flash`            |
| Region         | `europe-west1`                |
| Authentication | Application Default Credentials (SA key injected at VM boot) |

---

## Design Principles

1. **No credentials in code.** All secrets live in GCP Secret Manager and are
   injected at boot via the startup script. Nothing sensitive is committed.

2. **Stateless VM.** The VM can be destroyed and recreated from Terraform + the
   startup script. State lives in GitHub (issues, PRs) and GCS (tfstate).

3. **Single responsibility per service.** LiteLLM only proxies inference.
   The Gateway only receives webhooks. The Agent only implements issues.

4. **Idempotent provisioning.** The startup script and `provision.sh` can run
   multiple times without breaking the system.

---

## What NOT to do

- Do not hardcode the GitHub token, LiteLLM master key, or any secret in
  Terraform files, scripts, or config files.
- Do not expose LiteLLM on a public port — it must remain on `localhost:4000`.
- Do not run services as `root` — everything runs under the `hermess` user.
- Do not skip HMAC verification in the Gateway — it is the only auth boundary
  between the public internet and the agent.
