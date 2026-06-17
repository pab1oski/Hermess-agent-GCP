# Design — documentation

## Contexto

La documentación final reemplaza los templates del scaffold con contenido real del proyecto hermes-agent-gcp. Es la última feature porque depende de que todas las demás estén implementadas.

## Archivos modificados

| Archivo | Cambio |
|---------|--------|
| `README.md` | Reescrito con quick start, diagrama ASCII, prerequisites y badges |
| `docs/architecture.md` | Reescrito con arquitectura real de 3 capas |
| `docs/conventions.md` | Reescrito con convenciones HCL/Terraform |
| `docs/verification.md` | Reescrito con comandos de verificación en orden |

## Archivos creados

| Archivo | Responsabilidad |
|---------|----------------|
| (ninguno nuevo) | Todo va en archivos existentes |

## Estructura del README.md

```markdown
# Hermes Agent on GCP

> Un AI Software Engineer autónomo, deployable en minutos.

[Diagrama ASCII]

## Prerequisites
## Quick Start
  1. Bootstrap tfstate
  2. terraform init && apply
  3. SSH
  4. provision.sh
  5. setup-webhook.sh
  6. Crear issue de prueba
## Architecture
## Contributing
```

## docs/architecture.md — capas

```
GitHub ──────────────────────────────────────────────
  Issues (trigger) │ PRs (output) │ Comments (status)

GCP ─────────────────────────────────────────────────
  VM e2-standard-2 │ Service Account │ Secret Manager
  IP estática      │ Firewall rules

VM ──────────────────────────────────────────────────
  LiteLLM :4000 (proxy Vertex AI)
  Hermes Agent (AI Software Engineer)
  Gateway :8644 (webhook receiver)

Vertex AI ───────────────────────────────────────────
  gemini-2.5-pro  │ gemini-2.5-flash
```

## docs/conventions.md — convenciones HCL

- Naming: `{project_id}-{resource_type}` (ej: `myproject-vm`, `myproject-sa`)
- Un archivo por tipo de recurso: `main.tf`, `firewall.tf`, `outputs.tf`
- Variables siempre en `variables.tf` con `description` y `default`
- No usar `count` — usar `for_each` cuando se itera

## Alternativa descartada

Usar un generador de docs como Terraform-docs: descartado porque la documentación de arquitectura y quick start requiere contenido narrativo que no se genera automáticamente.
