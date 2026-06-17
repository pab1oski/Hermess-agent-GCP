# Design — terraform_infra

## Contexto

Se define la IaC mínima para desplegar la VM del agente en GCP. El stack es Terraform >= 1.5 con provider `google` ~> 5.0.

## Archivos creados / modificados

| Archivo | Responsabilidad |
|---------|----------------|
| `terraform/main.tf` | VM, IP estática, Service Account, binding de roles |
| `terraform/variables.tf` | Declaración de todas las variables con defaults |
| `terraform/outputs.tf` | `vm_ip`, `sa_email` expuestos para scripts downstream |
| `terraform/backend.tf` | Backend GCS con bucket parametrizable |
| `terraform/firewall.tf` | 2 reglas: SSH (22) y webhook (8644) |
| `terraform/terraform.tfvars.example` | Template con ejemplos comentados |
| `scripts/bootstrap-tfstate.sh` | Crea bucket GCS + habilita APIs |

## Decisiones técnicas

### VM
- Tipo `e2-standard-2` (2 vCPU, 8 GB RAM) — suficiente para LiteLLM + Hermes concurrentes.
- Disco boot de 50 GB SSD (configurable via `disk_size_gb`).
- Imagen `debian-cloud/debian-12`.
- La startup script se referencia desde `scripts/startup.sh` como `metadata_startup_script`.

### Networking
- IP estática reservada: el webhook de GitHub necesita una IP fija para la allowlist.
- Firewall SSH restringido a `ssh_allowed_cidr` (default `0.0.0.0/0`, recomendado acotar en prod).
- Firewall webhook abierto a `0.0.0.0/0` en puerto 8644 (GitHub IPs son cambiantes).

### Secret Manager
- 2 secretos vacíos creados por Terraform; el valor se carga manualmente o via CI.
- Naming: `{agent_name}-github-pat` y `{agent_name}-github-webhook-secret`.

### Backend remoto
- Bucket GCS nombrado `{project_id}-tfstate`; `bootstrap-tfstate.sh` lo crea antes del init.

## Alternativa descartada

Usar Pulumi: descartado porque el equipo ya conoce HCL y la toolchain de Terraform es estándar en GCP IaC.
