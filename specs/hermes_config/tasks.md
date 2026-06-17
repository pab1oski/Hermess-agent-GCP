# Tasks — hermes_config

- [x] T1 — Escribir `config/hermes/config.yaml` apuntando al proxy LiteLLM con modelo gemini-2.5-pro. Cubre: R1.
- [x] T2 — Añadir soporte para `AGENT_NAME` como variable de entorno en config.yaml. Cubre: R4.
- [x] T3 — Escribir `config/hermes/SOUL.md` con identidad y flujo clone→branch→implement→test→PR→comment. Cubre: R3.
- [x] T4 — Escribir `config/hermes/env.example` con todas las variables documentadas. Cubre: R5.
- [x] T5 — Actualizar `scripts/provision.sh` para copiar `config/hermes/` hacia `~/.hermes/`. Cubre: R1, R3.
- [ ] T6 — Verificar en VM: `hermes config check` termina sin errores. Cubre: R2.
- [ ] T7 — Verificar en VM: `hermes chat -q 'What is your name?'` devuelve el AGENT_NAME configurado. Cubre: R6.
