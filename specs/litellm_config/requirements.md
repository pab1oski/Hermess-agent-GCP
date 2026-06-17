# Requirements — litellm_config

## R1
El sistema DEBE proporcionar `config/litellm/config.yaml` con dos modelos configurados: `gemini-2.5-pro` y `gemini-2.5-flash`, apuntando a Vertex AI en la región `europe-west1`.

## R2
CUANDO LiteLLM está corriendo, el sistema DEBE autenticarse con Vertex AI usando Application Default Credentials (ADC) sin ninguna API key en texto plano en los archivos de configuración.

## R3
CUANDO se ejecuta `curl http://localhost:4000/v1/models` en la VM, la respuesta DEBE listar `gemini-2.5-pro` y `gemini-2.5-flash`.

## R4
El sistema DEBE exponer LiteLLM en `http://localhost:4000` con una interfaz compatible con la API de OpenAI (endpoint `/v1/chat/completions`).

## R5
El sistema DEBE configurar LiteLLM con un `master_key` leído desde la variable de entorno `LITELLM_MASTER_KEY`, no hardcodeado en el archivo de config.
