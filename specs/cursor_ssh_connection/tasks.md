# Tasks — cursor_ssh_connection

- [x] T1 — Escribir `scripts/generate-ssh-config.sh` que obtiene IP via terraform output y genera el bloque SSH. Cubre: R1, R2.
- [x] T2 — Añadir lógica de update (no duplicar) si ya existe `Host hermes-agent` en ~/.ssh/config. Cubre: R5.
- [x] T3 — Escribir `docs/cursor-ssh-guide.md` con las 7 secciones: prerequisites, SSH config, conexión, editar ~/.hermes/, skills, MCPs, troubleshooting. Cubre: R3, R4.
- [x] T4 — Ejecutar `shellcheck scripts/generate-ssh-config.sh` y corregir warnings.
- [ ] T5 — Verificar: ejecutar el script con VM desplegada y conectar exitosamente via `ssh hermes-agent`. Cubre: R1, R2.
