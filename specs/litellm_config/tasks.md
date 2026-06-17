# Tasks — litellm_config

- [x] T1 — Escribir `config/litellm/config.yaml` con los dos modelos Vertex AI en europe-west1. Cubre: R1.
- [x] T2 — Configurar autenticación via ADC (sin API keys en texto) en config.yaml. Cubre: R2.
- [x] T3 — Configurar `master_key` via variable de entorno `LITELLM_MASTER_KEY` en config.yaml. Cubre: R5.
- [x] T4 — Configurar el servidor en `host: 127.0.0.1, port: 4000` en config.yaml. Cubre: R4.
- [x] T5 — Actualizar `config/systemd/litellm.service` para pasar `GOOGLE_CLOUD_PROJECT` y `LITELLM_MASTER_KEY` como EnvironmentFile. Cubre: R2, R5.
- [ ] T6 — Verificar en VM desplegada: `curl http://localhost:4000/v1/models` lista ambos modelos. Cubre: R3.
