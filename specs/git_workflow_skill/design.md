# Design — git_workflow_skill

## Contexto

Los skills de Hermes Agent son archivos Markdown que definen instrucciones estructuradas para el agente. Se instalan en `~/.hermes/skills/` y el agente los carga al arrancar.

## Archivos creados / modificados

| Archivo | Responsabilidad |
|---------|----------------|
| `skills/git-workflow/SKILL.md` | Definición completa del skill: instrucciones, naming, templates |
| `skills/README.md` | Guía sobre cómo añadir skills custom al proyecto |

## Estructura del SKILL.md

```markdown
# Skill: git-workflow

## Trigger
CUANDO el agente recibe un issue de GitHub.

## Instrucciones
1. Clonar el repositorio del issue
2. Crear branch: {AGENT_NAME}/issue-{number}/{slug}
3. Implementar la solución
4. Escribir/actualizar tests
5. Ejecutar tests — NO abrir PR si hay fallos
6. Abrir PR usando el template PR_TEMPLATE
7. Comentar en el issue usando ISSUE_COMMENT_TEMPLATE

## Naming de ramas
- Formato: `{AGENT_NAME}/issue-{number}/{slug}`
- slug = título del issue en kebab-case, máximo 50 chars
- Ejemplo: `hermes/issue-42/add-user-authentication`

## PR_TEMPLATE
...

## ISSUE_COMMENT_TEMPLATE
...
```

## Instalación del skill

`provision.sh` copia `skills/git-workflow/` a `~/.hermes/skills/git-workflow/` y ejecuta `hermes skills install git-workflow` si el CLI lo requiere.

## Alternativa descartada

Definir el flujo directamente en SOUL.md sin skill separado: descartado porque mezclaría identidad del agente con procedimientos operativos, dificultando el mantenimiento y la extensibilidad con futuros skills.
