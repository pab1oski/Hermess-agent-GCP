# ejemplo-harness — Notes CLI

Proyecto de ejemplo que demuestra los principios de **Harness Engineering**
aplicados a un CLI minimalista de notas en Python.

> El código de la aplicación es deliberadamente simple. Lo importante de
> este repo no es **qué** hace, sino **cómo** está estructurado para que un
> agente de IA pueda trabajar sobre él de forma autónoma y verificable.

## Cómo está organizado el arnés

| Pilar | Manifestación en este repo |
|-------|----------------------------|
| **1. El repositorio ES el sistema** | `AGENTS.md`, `init.sh`, `feature_list.json`, `progress/`, `docs/` |
| **2. Orquestación multi-agente**    | `.claude/agents/leader.md`, `implementer.md`, `reviewer.md` |
| **3. Supervisión y mejora**         | `CHECKPOINTS.md`, hooks en `.claude/settings.json`, `tests/` |

## Para empezar

```bash
./init.sh
```

Si todo está verde, abre `AGENTS.md` y sigue desde ahí.

## Para usar la app (humanos)

```bash
python3 -m src.cli add "comprar pan" --body "y leche"
python3 -m src.cli list
```

## Demo del patrón Líder-Trabajador

```bash
python3 -m scripts.demo_orchestration
```

Simula al agente líder lanzando 3 subagentes en paralelo. Cada subagente
explora un módulo de `src/`, escribe su informe en `progress/explore_*.md`
y devuelve al líder **solo una referencia ligera** (ruta + tamaño). El
contenido nunca viaja por chat — esa es la regla anti-teléfono-descompuesto.

## Estructura

```
.
├── AGENTS.md              # Mapa para agentes (divulgación progresiva)
├── CHECKPOINTS.md         # Criterios de "estado final correcto"
├── feature_list.json      # Alcance: una feature a la vez
├── init.sh                # Verificación e inicialización
├── progress/
│   ├── current.md         # Sesión activa (estado vivo)
│   └── history.md         # Bitácora append-only
├── docs/
│   ├── architecture.md    # Qué significa "buen trabajo"
│   ├── conventions.md     # Estilo, nombres, errores
│   └── verification.md    # Cómo demostrar que funciona
├── .claude/
│   ├── agents/            # Definiciones de líder, implementador, revisor
│   └── settings.json      # Hooks que automatizan la verificación
├── src/
│   ├── storage.py         # Persistencia atómica (JSON)
│   ├── notes.py           # Modelo de dominio
│   └── cli.py             # Interfaz argparse
└── tests/
    ├── test_storage.py
    ├── test_notes.py
    └── test_cli.py
```

## Aprendizajes que ilustra este proyecto

- **Divulgación progresiva** en `AGENTS.md`: el agente no recibe todas las
  reglas de golpe, recibe un mapa para buscarlas bajo demanda.
- **Una feature a la vez** validado por `init.sh` (rechaza más de un
  `in_progress` en `feature_list.json`).
- **Estado en disco**, no en chat: `progress/current.md` y `history.md`
  sobreviven a reinicios y context windows reventadas.
- **Verificación ejecutable**: `init.sh` corre los tests reales, no se fía
  de lo que diga el agente.
- **Patrón Líder-Trabajador-Revisor**: el líder no implementa, el
  implementador no se autoaprueba, el revisor no edita código.
- **Anti teléfono-descompuesto**: los subagentes escriben sus resultados
  en archivos y solo devuelven una referencia ligera.
