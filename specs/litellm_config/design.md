# Design — litellm_config

## Contexto

LiteLLM actúa como proxy OpenAI-compatible entre Hermes Agent y Vertex AI. Hermes habla OpenAI API; Vertex AI no la implementa nativamente. LiteLLM traduce en tiempo real.

## Archivos creados / modificados

| Archivo | Responsabilidad |
|---------|----------------|
| `config/litellm/config.yaml` | Configuración completa del proxy: modelos, autenticación, puerto |

## Estructura del config.yaml

```yaml
model_list:
  - model_name: gemini-2.5-pro
    litellm_params:
      model: vertex_ai/gemini-2.5-pro
      vertex_project: "${GOOGLE_CLOUD_PROJECT}"
      vertex_location: europe-west1

  - model_name: gemini-2.5-flash
    litellm_params:
      model: vertex_ai/gemini-2.5-flash
      vertex_project: "${GOOGLE_CLOUD_PROJECT}"
      vertex_location: europe-west1

general_settings:
  master_key: "${LITELLM_MASTER_KEY}"

server:
  port: 4000
  host: 127.0.0.1
```

## Autenticación ADC

LiteLLM usa el provider `vertex_ai` que delega autenticación a `google-auth-library`. La VM tiene una Service Account con `roles/aiplatform.user`; la librería la detecta automáticamente via el metadata server de GCP sin necesidad de archivos de clave JSON.

## Variables de entorno requeridas

| Variable | Descripción |
|----------|-------------|
| `GOOGLE_CLOUD_PROJECT` | Project ID de GCP |
| `LITELLM_MASTER_KEY` | Key para proteger el proxy (generada en provision.sh) |

Ambas se inyectan al servicio systemd via `EnvironmentFile=~/.hermes/.env`.

## Alternativa descartada

Usar el proxy de Vertex AI Endpoints directamente desde Hermes: descartado porque Hermes Agent está diseñado para endpoints OpenAI-compatible y cambiar su cliente requeriría modificar el core del SDK.
