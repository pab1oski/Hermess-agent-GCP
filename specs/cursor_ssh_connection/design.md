# Design — cursor_ssh_connection

## Contexto

Cursor y VSCode con la extensión Remote-SSH permiten editar archivos en la VM como si fueran locales. Esto es especialmente útil para modificar `~/.hermes/` (config, SOUL.md, skills) sin necesidad de acceso SSH manual.

## Archivos creados / modificados

| Archivo | Responsabilidad |
|---------|----------------|
| `scripts/generate-ssh-config.sh` | Genera o actualiza el bloque SSH config |
| `docs/cursor-ssh-guide.md` | Guía paso a paso para conectar Cursor/VSCode |

## Lógica de generate-ssh-config.sh

```bash
VM_IP=$(cd terraform && terraform output -raw vm_ip)
SSH_BLOCK="Host hermes-agent
    HostName ${VM_IP}
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
    StrictHostKeyChecking no"

SSH_CONFIG="${HOME}/.ssh/config"

if grep -q "Host hermes-agent" "${SSH_CONFIG}" 2>/dev/null; then
  # Update existing block (sed multiline replacement)
  ...
else
  # Append new block
  echo "${SSH_BLOCK}" >> "${SSH_CONFIG}"
fi
echo "SSH config actualizado. Conecta con: ssh hermes-agent"
```

La actualización del bloque existente es el punto más complejo: se usa un enfoque de eliminar el bloque existente e insertar el nuevo.

## docs/cursor-ssh-guide.md — secciones

1. **Prerequisites**: Cursor o VSCode, extensión Remote-SSH instalada, clave SSH configurada
2. **Generar SSH config**: ejecutar `scripts/generate-ssh-config.sh`
3. **Conectar desde Cursor**: Remote Explorer → SSH → hermes-agent
4. **Editar configuración del agente**: navegar a `/home/ubuntu/.hermes/`
5. **Añadir skills custom**: crear carpeta en `~/.hermes/skills/` y editar SKILL.md
6. **Configurar MCPs**: editar `~/.hermes/config.yaml` sección `mcp_servers`
7. **Troubleshooting**: problemas comunes y soluciones

## Alternativa descartada

Usar VS Code Server en modo túnel (code tunnel): descartado porque requiere autenticación con cuenta GitHub o Microsoft y añade complejidad de auth. Remote-SSH es más directo y no tiene dependencias de cuenta.
