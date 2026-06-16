# Requirements — example_feature

> EARS notation. Un solo `DEBE` por requirement. Todos verificables por test.

---

## R1
CUANDO el usuario invoca la feature, el sistema DEBE producir el comportamiento observable descrito en el acceptance criterion.

## R2
SI la entrada no cumple el formato esperado ENTONCES el sistema DEBE retornar un error descriptivo y NO DEBE lanzar una excepción sin controlar.

## R3
CUANDO la operación completa con éxito, el sistema DEBE persistir el resultado en el almacenamiento definido en la arquitectura.

## R4
El sistema DEBE tener tests que cubran: el happy path (R1), el caso de entrada inválida (R2) y la persistencia (R3).
