# Tasks — example_feature

> Lista ordenada y ejecutable. Cada ítem es atómico — el implementer lo marca
> `[x]` al completarlo. El reviewer verifica trazabilidad contra requirements.md.

---

## Fase 1 — Setup

- [ ] Crear `src/example_feature.py` con la firma definida en `design.md`
- [ ] Crear `tests/test_example_feature.py` con estructura base (imports, fixtures)

## Fase 2 — Implementación core

- [ ] Implementar validación de input (cubre R2)
- [ ] Implementar lógica principal del happy path (cubre R1)
- [ ] Implementar persistencia del resultado (cubre R3)

## Fase 3 — Tests

- [ ] Test: happy path completo (R1)
- [ ] Test: input inválido → ValueError (R2)
- [ ] Test: verificar persistencia tras éxito (R3)

## Fase 4 — Integración

- [ ] Registrar módulo en `src/main.py`
- [ ] Verificar que `./init.sh` pasa sin errores

## Criterio de cierre

Todos los ítems marcados `[x]` + reviewer aprobó trazabilidad requirements ↔ tests.
