# Requirements — scaffold_cleanup

## R1
El sistema DEBE eliminar las carpetas `src/`, `tests/` y `specs/example_feature/` del repositorio.

## R2
El sistema DEBE crear las carpetas `terraform/`, `scripts/`, `config/hermes/`, `config/litellm/`, `config/systemd/` y `skills/git-workflow/`.

## R3
El sistema DEBE reescribir `feature_list.json` con las 10 features reales del proyecto hermes-agent-gcp, cada una con `id`, `name`, `title`, `description`, `acceptance`, `sdd: true` y `status` válido.

## R4
El sistema DEBE crear la carpeta `specs/<feature_name>/` para cada una de las 10 features, conteniendo exactamente tres archivos: `requirements.md`, `design.md` y `tasks.md` con contenido relevante a la feature.

## R5
El sistema DEBE reescribir `.gitignore` con reglas para Terraform (`.terraform/`, `*.tfstate`, etc.), secretos (`.env`, `*.pem`, `*.key`), Python (`__pycache__/`, `*.pyc`, `.venv/`) y OS (`.DS_Store`, `*.swp`).

## R6
CUANDO se ejecute `./init.sh`, el sistema DEBE terminar sin errores tras la limpieza y setup.
