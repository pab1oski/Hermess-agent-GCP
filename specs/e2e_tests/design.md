# Design — e2e_tests

## Contexto

Los smoke tests se ejecutan desde la máquina del operador (local o CI) después de un `terraform apply` exitoso. No requieren acceso a la consola GCP, solo SSH y Terraform instalados.

## Archivos creados / modificados

| Archivo | Responsabilidad |
|---------|----------------|
| `scripts/test-e2e.sh` | Smoke tests básicos via SSH |
| `scripts/test-e2e-full.sh` | Tests extendidos con inferencia real y webhook |

## Estructura de test-e2e.sh

```bash
#!/usr/bin/env bash
set -euo pipefail

VM_IP=$(cd terraform && terraform output -raw vm_ip)
SSH_CMD="ssh -o StrictHostKeyChecking=no ubuntu@${VM_IP}"
PASS=0; FAIL=0

check() {
  local name="$1"; shift
  if "$@" &>/dev/null; then
    echo "PASS: ${name}"; ((PASS++))
  else
    echo "FAIL: ${name}"; ((FAIL++))
  fi
}

check "SSH conecta"           $SSH_CMD "true"
check "hermes --version"      $SSH_CMD "hermes --version"
check "LiteLLM activo"        $SSH_CMD "curl -sf http://localhost:4000/health"
check "modelo gemini-2.5-pro" $SSH_CMD "curl -sf http://localhost:4000/v1/models | grep gemini-2.5-pro"
check "skill git-workflow"    $SSH_CMD "hermes skills list | grep git-workflow"
check "gateway activo"        $SSH_CMD "hermes gateway status | grep active"
check "gh autenticado"        $SSH_CMD "gh auth status"

echo ""; echo "Resultado: ${PASS} PASS, ${FAIL} FAIL"
[[ $FAIL -eq 0 ]]
```

## Obtención de IP via terraform output

Ejecutar `terraform output` requiere que el estado esté inicializado. El script hace `cd terraform` antes. Si terraform no está disponible, el script falla con un mensaje descriptivo.

## test-e2e-full.sh

Extiende con:
1. Test de inferencia real: llama a `gemini-2.5-flash` con un prompt simple y verifica respuesta no vacía.
2. Test HMAC: envía payload simulado con firma inválida → espera 401.
3. Test de branch naming: crea branch de prueba, verifica formato `{AGENT_NAME}/issue-0/test-branch`.

## Alternativa descartada

Usar pytest con `paramiko` para los tests SSH: descartado porque añade dependencia de Python en la máquina local del operador. Un script bash es ejecutable sin setup adicional.
