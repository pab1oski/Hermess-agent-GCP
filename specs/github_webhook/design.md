# Design — github_webhook

## Contexto

El gateway de Hermes es el punto de entrada de eventos de GitHub. Recibe webhooks HTTP, verifica la firma y despacha al agente. Corre como servicio systemd independiente del agente principal.

## Archivos creados / modificados

| Archivo | Responsabilidad |
|---------|----------------|
| `scripts/setup-webhook.sh` | Configura el webhook en Hermes: evento, secreto, habilita gateway |
| `config/systemd/hermes-gateway.service` | Unit file para el gateway como servicio persistente |

## Flujo del webhook

```
GitHub → POST :8644/webhook
  → Gateway verifica HMAC-SHA256
  → Si válido: deserializa payload
  → Filtra event_type == issues.opened
  → Lanza hermes run --skill git-workflow --input <payload>
```

## Verificación HMAC

El gateway de Hermes implementa verificación HMAC nativa. El secreto se pasa via variable de entorno `GITHUB_WEBHOOK_SECRET`, leída desde `~/.hermes/.env`.

## Puerto 8644

El puerto 8644 está abierto en el firewall GCP (Feature 2). GitHub enviará los webhooks a `http://<vm-ip>:8644/webhook`. La VM tiene IP estática (Feature 2).

## systemd unit para el gateway

```ini
[Unit]
Description=Hermes Agent Gateway
After=network.target litellm.service

[Service]
User=hermes
EnvironmentFile=/home/hermes/.hermes/.env
ExecStart=hermes gateway start --port 8644
Restart=always

[Install]
WantedBy=multi-user.target
```

## setup-webhook.sh

El script:
1. Lee `GITHUB_WEBHOOK_SECRET` del entorno
2. Configura el secreto en Hermes: `hermes webhook secret set $GITHUB_WEBHOOK_SECRET`
3. Registra la suscripción: `hermes webhook subscribe issues.opened --skill git-workflow`
4. Habilita e inicia el gateway: `systemctl enable --now hermes-gateway`

## Alternativa descartada

Usar un servidor Flask custom para recibir webhooks: descartado porque Hermes ya incluye un gateway nativo con verificación HMAC, reduciendo código propio y superficie de bugs.
