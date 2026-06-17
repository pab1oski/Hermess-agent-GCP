# Design — hermes_config

## Contexto

Hermes Agent (SDK de Nous Research) se configura mediante `~/.hermes/config.yaml` y un archivo de identidad `SOUL.md`. La configuración se copia desde el repo via `provision.sh`.

## Archivos creados / modificados

| Archivo | Responsabilidad |
|---------|----------------|
| `config/hermes/config.yaml` | Configuración base: modelo, endpoint LiteLLM, settings del agente |
| `config/hermes/SOUL.md` | Identidad, rol y flujo de trabajo del agente |
| `config/hermes/env.example` | Template documentado de variables de entorno |

## Estructura del config.yaml

```yaml
agent:
  name: "${AGENT_NAME}"
  soul_file: ~/.hermes/SOUL.md

model:
  provider: openai
  base_url: http://localhost:4000/v1
  api_key: "${LITELLM_MASTER_KEY}"
  model: gemini-2.5-pro
  max_tokens: 8192

tools:
  - bash
  - file_read
  - file_write
  - git
  - github
```

## SOUL.md — identidad y flujo

El SOUL.md define:
1. **Identidad**: nombre del agente, proyecto, propósito
2. **Flujo de trabajo**: al recibir un issue de GitHub, el agente DEBE:
   - Clonar el repo del issue
   - Crear branch con naming `${AGENT_NAME}/issue-<n>/<slug>`
   - Implementar la solución con tests
   - Abrir un PR con template estándar
   - Comentar en el issue con link al PR
3. **Restricciones**: no pushear a main directamente, no mergear PRs propios

## Variables de entorno (env.example)

```bash
AGENT_NAME=hermes          # Nombre único del agente
LITELLM_MASTER_KEY=...     # Key del proxy LiteLLM
GITHUB_TOKEN=...           # PAT con permisos repo + issues
GOOGLE_CLOUD_PROJECT=...   # GCP project ID
```

## Alternativa descartada

Usar variables de entorno para toda la config (sin config.yaml): descartado porque Hermes Agent requiere un archivo de config para settings complejos como tool definitions y soul_file path.
