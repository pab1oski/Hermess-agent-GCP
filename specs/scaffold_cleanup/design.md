# Design — scaffold_cleanup

## Contexto

El repo parte de un scaffold genérico con una notes app de ejemplo (`src/`, `tests/`, `specs/example_feature/`). Esta feature lo transforma en la estructura real del proyecto hermes-agent-gcp.

## Archivos eliminados

- `src/` — código de la notes app placeholder
- `tests/` — tests de la notes app placeholder
- `specs/example_feature/` — spec de ejemplo del scaffold

## Archivos / carpetas creados

| Ruta | Propósito |
|------|-----------|
| `terraform/` | IaC con archivos stub para Feature 2 |
| `scripts/` | Shell scripts con shebang; lógica en Features 3, 7, 8, 9 |
| `config/hermes/` | Config de Hermes Agent (Feature 5) |
| `config/litellm/` | Config del proxy LiteLLM (Feature 4) |
| `config/systemd/` | Unit files systemd (Features 3, 7) |
| `skills/git-workflow/` | Skill custom de git (Feature 6) |
| `specs/<10 features>/` | Specs completos con requirements, design y tasks |

## Archivos modificados

| Archivo | Cambio |
|---------|--------|
| `.gitignore` | Reemplazado con reglas para Terraform, secretos, Python, OS |
| `feature_list.json` | Reemplazado con las 10 features reales del proyecto |

## Decisión: archivos stub vs. vacíos

Los archivos en `terraform/`, `scripts/` y `config/` se crean con contenido mínimo (comentario `# TODO` o shebang) para que sean identificables por tipo y no generen errores en herramientas como `shellcheck`. El contenido real se implementa en las features correspondientes.

## Alternativa descartada

Usar un único script de bootstrap externo para crear la estructura: descartado porque requiere ejecutar código fuera del control del agente implementer y complica la trazabilidad de cambios en git.
