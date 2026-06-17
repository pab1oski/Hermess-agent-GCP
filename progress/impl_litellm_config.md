# Implementación — litellm_config

## Trazabilidad R → archivo modificado

| Req | Cobertura | Archivo |
|-----|-----------|---------|
| R1  | config.yaml declara gemini-2.5-pro y gemini-2.5-flash con vertex_ai/ en europe-west1 | config/litellm/config.yaml |
| R2  | La autenticación usa ADC implícita (vertex_ai/ provider usa las credenciales de la SA de la VM). No hay API key en texto. GOOGLE_CLOUD_PROJECT se inyecta desde .env via EnvironmentFile | config/litellm/config.yaml, config/systemd/litellm.service, scripts/startup.sh |
| R3  | Verificación manual en VM desplegada (T6, no ejecutable en CI) — los dos modelos quedan registrados en config.yaml | config/litellm/config.yaml |
| R4  | server.host = 127.0.0.1, server.port = 4000 en config.yaml | config/litellm/config.yaml |
| R5  | master_key: "${LITELLM_MASTER_KEY}" — el valor viene de Secret Manager y se escribe en .env por startup.sh; litellm.service lo lee via EnvironmentFile | config/litellm/config.yaml, config/systemd/litellm.service, scripts/startup.sh, terraform/main.tf |

## Archivos modificados

- `config/litellm/config.yaml` — implementación completa (era TODO)
- `config/systemd/litellm.service` — agregado EnvironmentFile=/home/hermess/.hermes/.env
- `scripts/startup.sh` — agrega lectura de PROJECT_ID y LITELLM_MASTER_KEY desde metadata/Secret Manager y los escribe en .env
- `terraform/main.tf` — nuevo resource google_secret_manager_secret.litellm_master_key

## Nota sobre T6

T6 requiere una VM real desplegada. No es ejecutable en este entorno. Queda pendiente de verificación manual post-deploy.
