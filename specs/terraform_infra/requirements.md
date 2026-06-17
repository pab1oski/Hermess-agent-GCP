# Requirements — terraform_infra

## R1
CUANDO el usuario ejecuta `terraform validate` en el directorio `terraform/`, el sistema DEBE terminar sin errores.

## R2
CUANDO el usuario ejecuta `terraform plan`, el sistema DEBE mostrar la creación de: 1 Service Account, 1 VM e2-standard-2, 1 IP estática, 2 reglas de firewall (SSH en puerto 22 y webhook en puerto 8644), 2 secretos en Secret Manager con naming `{agent_name}-github-pat` y `{agent_name}-github-webhook-secret`.

## R3
La Service Account creada DEBE tener exactamente los roles `roles/aiplatform.user` y `roles/secretmanager.secretAccessor` en el proyecto GCP.

## R4
El sistema DEBE declarar todas las variables configurables en `variables.tf`: `project_id`, `region`, `zone`, `agent_name`, `machine_type`, `disk_size_gb`, `ssh_allowed_cidr`, cada una con descripción. Las variables que tienen un valor razonable por defecto DEBEN incluirlo; `project_id` es requerida sin default (es específica de cada proyecto GCP).

## R5
El sistema DEBE proporcionar `terraform/terraform.tfvars.example` con todos los valores de ejemplo y comentarios explicativos para cada variable.

## R6
El sistema DEBE proporcionar `scripts/bootstrap-tfstate.sh` que crea el bucket GCS de estado remoto y habilita las APIs necesarias (compute, secretmanager, aiplatform) antes del primer `terraform init`.
