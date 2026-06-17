# Implementación: github_webhook (Feature 7)

## Archivos creados/modificados

| Archivo | Acción |
|---------|--------|
| `config/systemd/hermes-gateway.service` | Creado |
| `scripts/setup-webhook.sh` | Implementado (era stub) |
| `scripts/startup.sh` | Añadida sección hermes-gateway |

## Traceability

| Req | Archivo(s) |
|-----|------------|
| R1 | `config/systemd/hermes-gateway.service` (port 8644) |
| R2 | Hermes gateway nativo — secreto via GITHUB_WEBHOOK_SECRET en .env |
| R3 | `scripts/setup-webhook.sh` (subscribe issues.opened --skill git-workflow) |
| R4 | `config/systemd/hermes-gateway.service` + `scripts/startup.sh` |
| R5 | Verificación manual pendiente (VM) |
| R6 | `scripts/setup-webhook.sh` (hermes webhook subscribe) |
| R7 | `scripts/setup-webhook.sh` |

## Notas

T4-T7 son verificaciones manuales que requieren VM desplegada.
setup-webhook.sh debe correrse manualmente después del primer boot (necesita que el gateway esté instalado y los secretos disponibles).
