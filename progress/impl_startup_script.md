# Implementación: startup_script

## Trazabilidad Requirements → Archivos

| Req | Cobertura | Archivo |
|-----|-----------|---------|
| R1 | Instala git, python3.11, python3-pip, python3-venv, curl, gnupg, Docker, gh, hermes-agent, litellm | `scripts/startup.sh` |
| R2 | Guards `command -v docker` y `command -v gh` antes de instalar; apt-get install -y es idempotente; pip install --upgrade es idempotente | `scripts/startup.sh` |
| R3 | `gcloud secrets versions access latest` para ambos secretos; escribe `~/.hermes/.env`; `chmod 600` | `scripts/startup.sh` |
| R4 | Copia `config/hermes/` → `~/.hermes/`; instala cada `skills/*/SKILL.md`; copia litellm config | `scripts/provision.sh` |
| R5 | shellcheck pasa con exit 0, 0 errores, 0 warnings (verificado con shellcheck 0.11.0) | `scripts/startup.sh`, `scripts/provision.sh` |
| R6 | Copia `litellm.service` a `/etc/systemd/system/`; `systemctl daemon-reload && enable --now litellm` | `scripts/startup.sh`, `config/systemd/litellm.service` |

## Cambios Terraform

- `terraform/main.tf`: reemplazó `metadata_startup_script` por bloque `metadata` con `startup-script`, `agent-name`, `repo-url`
- `terraform/variables.tf`: agregó `variable "repo_url"`
- `terraform/terraform.tfvars.example`: agregó ejemplo comentado de `repo_url`

## Notas

- `shellcheck` no estaba disponible en el PATH; se descargó el binario estático desde GitHub releases (v0.11.0) y pasó sin errores.
- El script usa `${REPO_URL#https://}` para strip del prefijo al inyectar el PAT en la URL de clone (no necesita comillas extra — shellcheck lo valida).
