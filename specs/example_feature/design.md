# Design — example_feature

> Decisiones técnicas previas a la implementación. No contiene código de
> aplicación — solo firmas, estructuras y justificaciones.

---

## 1. Archivos afectados

### Nuevos

| Archivo | Propósito |
|---|---|
| `src/example_feature.py` | Lógica principal de la feature |
| `tests/test_example_feature.py` | Suite de tests unitarios e integración |

### Modificados

| Archivo | Cambio |
|---|---|
| `src/main.py` | Registrar el nuevo módulo en el punto de entrada |

---

## 2. Interfaces clave

```python
def run_example_feature(input: str) -> Result:
    """
    Punto de entrada público.
    Raises: ValueError si input está vacío.
    """
```

---

## 3. Decisiones técnicas

| Decisión | Alternativas descartadas | Justificación |
|---|---|---|
| Módulo independiente | Inline en main | Facilita testeo aislado |
| ValueError para input inválido | Código de error custom | Estándar Python, consistente con el resto del repo |

---

## 4. Riesgos

- Ninguno identificado para esta feature de ejemplo.
