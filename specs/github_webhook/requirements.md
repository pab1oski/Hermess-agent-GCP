# Requirements — github_webhook

## R1
El sistema DEBE configurar el gateway de Hermes para escuchar eventos `issues.opened` de GitHub en el puerto 8644.

## R2
CUANDO GitHub envía un evento `issues.opened`, el sistema DEBE verificar la firma HMAC-SHA256 del payload usando el secreto `github-webhook-secret` antes de procesar el evento.

## R3
CUANDO la firma HMAC es válida, el sistema DEBE disparar el agente con el skill `git-workflow` pasando el payload del issue.

## R4
El gateway DEBE correr como servicio systemd persistente, habilitado para arrancar automáticamente en reboot.

## R5
CUANDO se ejecuta `hermes gateway status`, el sistema DEBE reportar que el gateway está activo.

## R6
CUANDO se ejecuta `hermes webhook list`, el sistema DEBE mostrar la suscripción a `issues.opened`.

## R7
El sistema DEBE proporcionar `scripts/setup-webhook.sh` que automatiza la configuración del webhook en Hermes (registrar evento, configurar secreto, habilitar gateway).
