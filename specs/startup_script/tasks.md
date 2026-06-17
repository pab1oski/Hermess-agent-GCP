# Tasks — startup_script

- [x] T1 — Escribir `scripts/startup.sh` con shebang, set -euo pipefail, instalación de dependencias. Cubre: R1, R5.
- [x] T2 — Añadir bloque de idempotencia en startup.sh (checks antes de instalar Docker). Cubre: R2.
- [x] T3 — Añadir bloque de extracción de secretos desde Secret Manager y escritura de ~/.hermes/.env. Cubre: R3.
- [x] T4 — Añadir instalación y habilitación de litellm.service al final de startup.sh. Cubre: R6.
- [x] T5 — Escribir `scripts/provision.sh`: copia config/hermes/ → ~/.hermes/ e instala skills/. Cubre: R4.
- [x] T6 — Escribir `config/systemd/litellm.service` con ExecStart, Restart=always, WantedBy=multi-user.target. Cubre: R6.
- [x] T7 — Ejecutar `shellcheck scripts/startup.sh` y corregir todos los warnings. Cubre: R5.
