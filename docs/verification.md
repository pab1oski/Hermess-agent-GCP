# Verificación — Cómo demostrar que el trabajo funciona

> Regla de oro: **el agente no dice "funciona", lo demuestra**.
> Toda feature termina con evidencia ejecutable, no con afirmaciones.
>
> **PLANTILLA:** reemplaza los comandos con los del proyecto real.
> Elimina este aviso cuando esté completo.

## Niveles de verificación

### Nivel 1 — Tests unitarios (obligatorio)

Toda función pública tiene al menos un test que:

1. Cubre el camino feliz.
2. Cubre al menos un camino de error si la función puede fallar.

Comando:
```bash
# reemplaza con el comando de tests real
./init.sh
```

### Nivel 2 — Test de integración (obligatorio para features de UI/API)

_Describe cómo verificar el sistema end-to-end. Incluye un ejemplo ejecutable._

### Nivel 3 — Smoke test manual (opcional pero recomendado)

_Secuencia de comandos manuales para verificar el flujo principal._

## Anti-patrones (no hacer)

- ❌ "He añadido el código, debería funcionar." → falta test ejecutable.
- ❌ Test que solo verifica que no lanza excepción. → tiene que comprobar
  el resultado concreto.
- ❌ Marcar la feature como `done` sin pasar `./init.sh`.

## Verificación final antes de cerrar

```bash
./init.sh           # debe terminar con [OK] Entorno listo
```
