# Requirements — hermes_config

## R1
El sistema DEBE proporcionar `config/hermes/config.yaml` que apunta el modelo base de Hermes al proxy LiteLLM en `http://localhost:4000` usando el modelo `gemini-2.5-pro`.

## R2
CUANDO se ejecuta `hermes config check`, el sistema DEBE terminar sin errores de configuración.

## R3
El sistema DEBE proporcionar `config/hermes/SOUL.md` que define la identidad del agente y el flujo de trabajo: clone → branch → implement → test → PR → comment en issue.

## R4
El nombre del agente DEBE ser configurable mediante la variable de entorno `AGENT_NAME`, sin que sea necesario editar ningún archivo de configuración para cambiarlo.

## R5
El sistema DEBE proporcionar `config/hermes/env.example` como template documentado de todas las variables de entorno requeridas por el agente.

## R6
CUANDO se ejecuta `hermes chat -q 'What is your name?'` con `AGENT_NAME` configurado, el sistema DEBE responder con el nombre configurado en `AGENT_NAME`.
