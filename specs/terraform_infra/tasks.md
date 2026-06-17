# Tasks — terraform_infra

- [x] T1 — Escribir `terraform/variables.tf` con las 7 variables documentadas. Cubre: R4.
- [x] T2 — Escribir `terraform/backend.tf` con backend GCS parametrizado. Cubre: R1.
- [x] T3 — Escribir `terraform/main.tf`: VM e2-standard-2, IP estática, Service Account con roles. Cubre: R2, R3.
- [x] T4 — Escribir `terraform/firewall.tf`: regla SSH puerto 22 + regla webhook puerto 8644. Cubre: R2.
- [x] T5 — Escribir `terraform/outputs.tf`: exportar `vm_ip` y `sa_email`. Cubre: R2.
- [x] T6 — Crear `terraform/terraform.tfvars.example` con todos los valores de ejemplo comentados. Cubre: R5.
- [x] T7 — Escribir `scripts/bootstrap-tfstate.sh`: crea bucket GCS + habilita APIs. Cubre: R6.
- [x] T8 — Ejecutar `terraform validate` y verificar que pasa sin errores. Cubre: R1.
