# Tasks — github_webhook

- [x] T1 — Escribir `config/systemd/hermes-gateway.service` con EnvironmentFile, ExecStart y Restart=always. Cubre: R4.
- [x] T2 — Escribir `scripts/setup-webhook.sh` que configura secreto, suscripción a issues.opened y habilita el gateway. Cubre: R7.
- [x] T3 — Actualizar `scripts/startup.sh` para instalar y habilitar hermes-gateway.service. Cubre: R4.
- [ ] T4 — Verificar en VM: `hermes gateway status` reporta activo. Cubre: R5.
- [ ] T5 — Verificar en VM: `hermes webhook list` muestra suscripción a issues.opened. Cubre: R6.
- [ ] T6 — Verificar verificación HMAC: enviar payload con firma inválida → gateway rechaza con 401. Cubre: R2.
- [ ] T7 — Verificar flujo completo: enviar payload válido issues.opened → agente se dispara con skill git-workflow. Cubre: R1, R3.
