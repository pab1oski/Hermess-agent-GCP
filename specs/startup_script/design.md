# Design — startup_script

## Contexto

La VM se provisiona automáticamente en el primer boot mediante la metadata `startup-script` de GCP Compute Engine. El script tiene que ser idempotente porque puede correr de nuevo en reboots o manualmente.

## Archivos creados / modificados

| Archivo | Responsabilidad |
|---------|----------------|
| `scripts/startup.sh` | Script de cloud-init: instala dependencias, configura secretos, arranca servicios |
| `scripts/provision.sh` | Copia config de Hermes e instala skills locales desde el repo |
| `config/systemd/litellm.service` | Unit file para LiteLLM como servicio persistente |

## Flujo de startup.sh

```
1. apt-get update + install git python3.11 python3-pip
2. Install Docker via script oficial (idempotente con check)
3. Install GitHub CLI via apt
4. pip install hermes-agent litellm (con --upgrade)
5. Fetch secretos desde Secret Manager via gcloud
6. Escribir ~/.hermes/.env con chmod 600
7. Copiar config/systemd/litellm.service → /etc/systemd/system/
8. systemctl daemon-reload && enable --now litellm
```

## Idempotencia

- Instalar paquetes con `apt-get install -y` es idempotente por diseño.
- Instalar con `pip install --upgrade` es idempotente.
- Copiar archivos de config es idempotente (sobreescribe).
- `systemctl enable --now` es idempotente.
- Para `gcloud secrets versions access`: se ejecuta siempre para refrescar el valor.

## Secretos

Los secretos se obtienen con:
```bash
gcloud secrets versions access latest --secret="${AGENT_NAME}-github-pat"
```
La SA de la VM tiene el rol `secretmanager.secretAccessor`, sin necesidad de credenciales adicionales.

## Alternativa descartada

Ansible para la provisión: descartado porque añade una dependencia de control externo y el objetivo es que la VM sea autosuficiente desde el primer boot sin orquestador externo.
