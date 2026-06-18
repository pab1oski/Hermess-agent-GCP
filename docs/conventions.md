# Conventions — Terraform / HCL

This document defines the conventions used in the `terraform/` directory.
All contributors and AI agents must follow these rules before writing or reviewing HCL.

---

## Naming

Resources follow the pattern `{project}-{resource}-{env}` where:
- `{project}` maps to `var.agent_name` (e.g., `hermess-agent`)
- `{resource}` is the resource type (e.g., `vm`, `sa`, `ip`)
- `{env}` is omitted in this project because it is a single-environment deployment — the `agent_name` already serves as the environment discriminator

All names are computed in a `locals {}` block. Never hardcode resource names inline.

```hcl
locals {
  vm_name      = "${var.agent_name}-vm"
  sa_name      = "${var.agent_name}-sa"
  ip_name      = "${var.agent_name}-ip"
  secret_gh    = "${var.agent_name}-gh-token"
  secret_llm   = "${var.agent_name}-litellm-master-key"
}
```

Secret IDs follow the same pattern: `{agent_name}-{purpose}` (e.g., `hermess-agent-gh-token`).

---

## File Structure

| File                      | Contents                                         |
|---------------------------|--------------------------------------------------|
| `main.tf`                 | All resources, grouped by logical concern        |
| `variables.tf`            | All input variables with `description` and `type`|
| `outputs.tf`              | All outputs with `description`                   |
| `versions.tf`             | `terraform {}` block + `required_providers`      |
| `terraform.tfvars.example`| Example values for all variables (committed)     |
| `terraform.tfvars`        | Actual values (gitignored, never committed)      |

No nested modules — the project uses a flat single-module structure for simplicity.

---

## Resource Grouping in `main.tf`

Group resources by logical concern, separated by comment headers:

```hcl
# --- Service Account ---
resource "google_service_account" "sa" { ... }

# --- Secret Manager ---
resource "google_secret_manager_secret" "gh_token" { ... }

# --- Network ---
resource "google_compute_address" "ip" { ... }
resource "google_compute_firewall" "allow_ssh" { ... }

# --- VM ---
resource "google_compute_instance" "vm" { ... }
```

---

## Variables Policy

All variables live in `variables.tf`.

- Every variable must have `description` and `type`.
- Sensitive variables (tokens, keys) have **no `default`** — this forces explicit setting.
- Non-sensitive variables have a documented `default`.
- Never commit `terraform.tfvars` — only commit `terraform.tfvars.example`.

```hcl
# Sensitive — no default
variable "gh_token" {
  description = "GitHub personal access token for the agent."
  type        = string
  sensitive   = true
}

# Non-sensitive — documented default
variable "region" {
  description = "GCP region for the VM."
  type        = string
  default     = "us-central1"
}
```

---

## Iteration

Use `for_each` when iterating over collections. Never use `count` for resources
that have meaningful identities (firewall rules, secrets, etc.).

```hcl
# Correct
resource "google_secret_manager_secret" "secrets" {
  for_each  = toset(["gh-token", "litellm-master-key"])
  secret_id = "${var.agent_name}-${each.key}"
}

# Wrong
resource "google_secret_manager_secret" "secrets" {
  count     = 2
  secret_id = "${var.agent_name}-secret-${count.index}"
}
```

---

## Outputs

All outputs live in `outputs.tf` and must have `description`.
Scripts consume outputs via `terraform output -raw <name>`.

```hcl
output "vm_ip" {
  description = "Public IP address of the Hermes Agent VM."
  value       = google_compute_address.ip.address
}
```

---

## State

Remote state is stored in a GCS bucket bootstrapped by `scripts/bootstrap-tfstate.sh`.

- Bucket name: `{project_id}-tfstate`
- Never use local state in this project.
- The backend block lives in `versions.tf`.

---

## Secrets

Secrets are never stored in code, `.tfvars`, or environment variables on the host.
They live exclusively in GCP Secret Manager and are retrieved by the VM at boot.
