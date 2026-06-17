# Tasks — e2e_tests

- [ ] T1 — Escribir `scripts/test-e2e.sh` con función `check()` y los 7 checks básicos via SSH. Cubre: R1, R2.
- [ ] T2 — Añadir obtención automática de IP via `terraform output -raw vm_ip` en test-e2e.sh. Cubre: R3.
- [ ] T3 — Añadir exit code 0 cuando todos los checks pasan, exit code 1 cuando alguno falla. Cubre: R4, R5.
- [ ] T4 — Escribir `scripts/test-e2e-full.sh` con checks de inferencia, HMAC y branch naming. Cubre: R6.
- [ ] T5 — Ejecutar `shellcheck` en ambos scripts y corregir todos los warnings.
- [ ] T6 — Verificar en VM correctamente desplegada: `scripts/test-e2e.sh` reporta 7/7 PASS. Cubre: R4.
