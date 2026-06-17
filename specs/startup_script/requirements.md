# Requirements — startup_script

## R1
El sistema DEBE proporcionar `scripts/startup.sh` que se ejecuta como cloud-init al primer boot de la VM e instala: Docker, Git, Python 3.11, GitHub CLI (`gh`), Hermes Agent y LiteLLM.

## R2
El sistema DEBE garantizar que `scripts/startup.sh` es idempotente: ejecutarlo múltiples veces NO DEBE romper la VM ni reinstalar paquetes innecesariamente.

## R3
CUANDO la VM arranca, el sistema DEBE extraer los secretos `github-pat` y `github-webhook-secret` de GCP Secret Manager usando las credenciales de la Service Account y escribirlos en `~/.hermes/.env` con permisos `chmod 600`.

## R4
El sistema DEBE proporcionar `scripts/provision.sh` que copia la configuración de Hermes desde `config/hermes/` hacia `~/.hermes/` e instala los skills locales desde `skills/`.

## R5
CUANDO `shellcheck scripts/startup.sh` se ejecuta, el sistema NO DEBE reportar errores de nivel error o warning.

## R6
El sistema DEBE iniciar LiteLLM como servicio systemd usando el unit file `config/systemd/litellm.service`, habilitado para arrancar automáticamente en reboot.
