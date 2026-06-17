# Implementación: hermes_config (Feature 5)

## Archivos creados/modificados

| Archivo | Acción |
|---------|--------|
| `config/hermes/config.yaml` | Implementado (era stub) |
| `config/hermes/SOUL.md` | Implementado (era stub) |
| `config/hermes/env.example` | Implementado (era stub) |
| `scripts/provision.sh` | Sin cambios (ya copiaba config/hermes/) |

## Traceability

| Req | Archivo(s) |
|-----|------------|
| R1 | `config/hermes/config.yaml` (base_url → localhost:4000, model → gemini-2.5-pro) |
| R2 | `config/hermes/config.yaml` + provision.sh (verificación manual pendiente) |
| R3 | `config/hermes/SOUL.md` |
| R4 | `config/hermes/config.yaml` (agent.name: "${AGENT_NAME}") |
| R5 | `config/hermes/env.example` |
| R6 | `config/hermes/config.yaml` + SOUL.md (verificación manual pendiente) |

## Notas

T6 y T7 son verificaciones manuales que requieren VM desplegada y hermes instalado.
