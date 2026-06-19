# Skills — cómo añadir skills custom

Los skills de Hermes Agent son archivos Markdown que definen instrucciones estructuradas para el agente. Se instalan en `~/.hermes/skills/` en la VM.

## Estructura de un skill

```
skills/
  <nombre-del-skill>/
    SKILL.md    # Definición del skill: trigger, instrucciones, templates
```

## Cómo añadir un skill nuevo

1. Crear la carpeta `skills/<nombre>/` en este repo.
2. Escribir `SKILL.md` siguiendo el formato del skill `git-workflow` como referencia.
3. El script `scripts/provision.sh` copia automáticamente todos los skills de esta carpeta a `~/.hermes/skills/` en la VM.
4. Reconectar al gateway o reiniciar Hermes para que cargue el nuevo skill.

## Skills disponibles

| Skill | Descripción |
|-------|-------------|
| `git-workflow` | Workflow SDD completo: Analyze → Implement → Verify → Ship |
