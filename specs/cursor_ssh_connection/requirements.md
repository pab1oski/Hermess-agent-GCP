# Requirements — cursor_ssh_connection

## R1
El sistema DEBE proporcionar `scripts/generate-ssh-config.sh` que genera un bloque `~/.ssh/config` válido con la IP obtenida automáticamente desde `terraform output -raw vm_ip`.

## R2
El bloque SSH config generado DEBE incluir: `Host hermes-agent`, `HostName <vm-ip>`, `User ubuntu`, `IdentityFile ~/.ssh/id_rsa` y `StrictHostKeyChecking no`.

## R3
El sistema DEBE proporcionar `docs/cursor-ssh-guide.md` que cubre paso a paso: instalación de la extensión Remote-SSH en Cursor/VSCode, configuración del SSH config, conexión a la VM, gestión de skills desde Cursor y configuración de MCPs.

## R4
Siguiendo la guía `docs/cursor-ssh-guide.md`, un operador DEBE poder conectarse a la VM y editar archivos en `~/.hermes/` desde Cursor sin conocimientos previos de SSH.

## R5
`scripts/generate-ssh-config.sh` DEBE detectar si ya existe un bloque `Host hermes-agent` en `~/.ssh/config` y, en ese caso, actualizarlo en lugar de duplicarlo.
