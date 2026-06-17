# Requirements — documentation

## R1
`README.md` DEBE contener un quick start completo con los pasos: (1) ejecutar bootstrap-tfstate.sh, (2) terraform init + apply, (3) SSH a la VM, (4) ejecutar provision.sh, (5) ejecutar setup-webhook.sh, (6) crear un issue de prueba en GitHub.

## R2
`docs/architecture.md` DEBE describir las capas del sistema: GCP (VM, SA, Secret Manager, firewall) → VM (LiteLLM, Hermes Agent, Gateway) → GitHub (Webhook, Issues, PRs).

## R3
`docs/conventions.md` DEBE definir las convenciones HCL/Terraform del proyecto: naming de recursos (`{project}-{resource}-{env}`), estructura de módulos, política de variables y outputs.

## R4
`docs/verification.md` DEBE listar los comandos de verificación end-to-end en orden: desde `terraform validate` hasta la recepción del primer webhook real y la apertura del primer PR automático.

## R5
`README.md` DEBE incluir un diagrama ASCII de la arquitectura del sistema.

## R6
`README.md` DEBE incluir una sección de prerequisites con versiones mínimas: Terraform >= 1.5, gcloud CLI, gh CLI, shellcheck.
