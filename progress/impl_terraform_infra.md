# Trazabilidad — terraform_infra

## Mapa R → Task → Archivo

| Requirement | Task(s) | Archivo(s) | Descripción |
|-------------|---------|------------|-------------|
| R1: terraform validate sin errores | T2, T8 | terraform/backend.tf, todos los .tf | T2 define provider + backend; T8 ejecutó `terraform validate` con resultado SUCCESS. |
| R2: plan muestra 1 SA, 1 VM e2-standard-2, 1 IP estática, 2 reglas firewall, 2 secrets | T3, T4, T5 | terraform/main.tf, terraform/firewall.tf, terraform/outputs.tf | main.tf define SA, VM (e2-standard-2, Debian 12, 50GB SSD), IP estática y 2 secrets SM. firewall.tf define SSH (22) y webhook (8644). outputs.tf exporta vm_ip y sa_email. |
| R3: SA con roles/aiplatform.user y roles/secretmanager.secretAccessor | T3 | terraform/main.tf | google_project_iam_member × 2 en main.tf. |
| R4: 7 variables en variables.tf con descripción y default | T1 | terraform/variables.tf | project_id, region, zone, agent_name, machine_type, disk_size_gb, ssh_allowed_cidr — todas con description y default (excepto project_id que es required). |
| R5: terraform.tfvars.example con valores de ejemplo comentados | T6 | terraform/terraform.tfvars.example | Todos los valores con comentarios explicativos. |
| R6: bootstrap-tfstate.sh crea bucket GCS y habilita APIs | T7 | scripts/bootstrap-tfstate.sh | Habilita compute, secretmanager y aiplatform APIs. Crea bucket {project_id}-tfstate con versioning. |

## Resultado de terraform validate

```
Success! The configuration is valid.
```

Ejecutado con `terraform init -backend=false && terraform validate` desde `terraform/`.

## Archivos creados / modificados

- `terraform/variables.tf` — 7 variables configurables
- `terraform/backend.tf` — provider google ~>5.0, terraform >=1.5, backend GCS
- `terraform/main.tf` — Service Account, IAM bindings, static IP, VM, 2 Secret Manager secrets
- `terraform/firewall.tf` — reglas SSH (22) y webhook (8644)
- `terraform/outputs.tf` — outputs vm_ip y sa_email
- `terraform/terraform.tfvars.example` — valores de ejemplo comentados
- `scripts/bootstrap-tfstate.sh` — bootstrap de bucket GCS + APIs
