# Requirements — git_workflow_skill

## R1
El sistema DEBE proporcionar `skills/git-workflow/SKILL.md` que define el skill custom de git workflow para Hermes Agent.

## R2
CUANDO se ejecuta `hermes skills list` en la VM, el sistema DEBE mostrar `git-workflow` como skill instalado.

## R3
El skill DEBE definir el naming de ramas como `<agent_name>/issue-<number>/<slug>` donde `slug` es un kebab-case del título del issue (máximo 50 caracteres).

## R4
El skill DEBE incluir un template de PR body con: descripción del cambio, referencia al issue (`Closes #<n>`), checklist de tests ejecutados y sección de notas para el reviewer.

## R5
El skill DEBE incluir un template de comment en issue que el agente posta al abrir el PR, con link al PR y resumen de los cambios realizados.

## R6
CUANDO `provision.sh` se ejecuta en la VM, el sistema DEBE instalar automáticamente el skill `git-workflow` desde la carpeta `skills/` del repo.
