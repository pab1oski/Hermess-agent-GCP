# Sesión actual

Feature en curso: 8 — e2e_tests

## Estado

T1-T5 completadas:
- `scripts/test-e2e.sh` implementado (7 checks vía gcloud compute ssh)
- `scripts/test-e2e-full.sh` implementado (inference, HMAC, branch naming)
- `terraform/outputs.tf` ampliado con vm_name y vm_zone
- `README.md` reescrito con quick-start completo y correcto

T6 pendiente: verificación en VM desplegada.

## Próximo paso

Seguir la guía del README para desplegar la infra y correr `./scripts/test-e2e.sh` contra la VM real.
