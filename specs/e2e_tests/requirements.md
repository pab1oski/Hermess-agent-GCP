# Requirements — e2e_tests

## R1
El sistema DEBE proporcionar `scripts/test-e2e.sh` ejecutable desde la máquina local que verifica via SSH los componentes de la VM.

## R2
`scripts/test-e2e.sh` DEBE reportar PASS o FAIL para cada uno de estos checks: SSH conecta, `hermes --version` responde, LiteLLM está activo (puerto 4000), los modelos gemini-2.5-pro y gemini-2.5-flash están disponibles, el skill git-workflow está instalado, el gateway está activo y `gh` está autenticado.

## R3
El script DEBE obtener la IP de la VM automáticamente desde `terraform output -raw vm_ip`, sin que el usuario tenga que escribirla manualmente.

## R4
CUANDO todos los checks pasan en una VM correctamente desplegada, el script DEBE terminar con exit code 0.

## R5
CUANDO al menos un check falla, el script DEBE terminar con exit code != 0 y mostrar claramente qué checks fallaron.

## R6
El sistema DEBE proporcionar `scripts/test-e2e-full.sh` con checks extendidos: latencia del modelo (test de inferencia real), prueba de firma HMAC del webhook, test de creación de branch con el naming correcto.
