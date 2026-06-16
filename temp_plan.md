# Análisis del Brief — Decisiones sin resolver

> Archivo de trabajo interno. Se actualiza a medida que se resuelven dudas con el usuario.
> Estado: EN PROCESO DE CLARIFICACIÓN

---

## 🔴 BLOCKERS CRÍTICOS (sin esto no se puede diseñar nada)

### B1 — ¿Qué es exactamente "Hermes Agent (de Nous Research)"? ✅ RESUELTO
- Es un SDK de agentes de código open-source de Nous Research (MIT License), similar a Claude Code / OpenClaw.
- Instalación en Linux: `curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash`
- Versión actual: v0.16.0
- CLI completa confirmada: `hermes profile create`, `hermes gateway`, `hermes webhook subscribe`, `hermes skills install`, `hermes chat`, etc.
- Terminal backends: local, **docker** (el que nos interesa), ssh, modal, singularity.
- **CORRECCIÓN AL BRIEF**: El puerto del proxy de Hermes es **8645** (no 8644 como dice el brief). El dashboard corre en **9119**.
- El gateway (`hermes gateway`) es el servidor de webhooks/mensajería (Telegram, Discord, GitHub, etc.).
- Perfiles: `hermes profile create <name>` sí existe y funciona como describe el brief.
- Soporte de modelos: 300+ modelos vía providers configurables (OpenRouter, OpenAI-compatible, custom endpoints).

### B2 — Modelos Gemini ✅ RESUELTO
- Orquestador (planner): **gemini-2.5-pro** en Vertex AI
- Workers (ejecución paralela): **gemini-2.5-flash** en Vertex AI
- LiteLLM traducirá las llamadas del agente (formato OpenAI) a Vertex AI nativo.

### B3 — GCP Project ✅ RESUELTO
- Proyecto existente. `project_id`: **telegram-agent-496807**
- Terraform solo despliega recursos (VM, SA, firewall, IP). No crea proyecto ni activa APIs desde cero.

---

## 🟠 DECISIONES DE ARQUITECTURA (necesarias antes de escribir código)

### A1 — Terraform State Backend ✅ RESUELTO
- Backend: **GCS bucket** en proyecto `telegram-agent-496807`.
- Nombre del bucket: `telegram-agent-496807-tfstate` (convención: `<project_id>-tfstate`).
- El bucket se crea manualmente ANTES del primer `terraform init` (bootstrap step documentado).
- Configuración en `backend.tf`: `bucket = "telegram-agent-496807-tfstate"`, `prefix = "hermes-agent"`.

### A2 — GitHub Auth ✅ RESUELTO
- Método: **Fine-Grained PAT** (repos personales o donde el usuario es admin).
- El token se guarda en **GCP Secret Manager** (rol adicional `roles/secretmanager.secretAccessor` en la SA).
- Permisos mínimos del PAT: `contents:write`, `pull-requests:write`, `issues:read`.

### A3 — Telegram ✅ RESUELTO
- **Fuera de scope v1.** Se documenta como extensión futura vía `hermes gateway`.

### A4 — Región y zona de GCP ✅ RESUELTO
- Región: **europe-west1** (Belgium) — Vertex AI con Gemini disponible.
- Zona: **europe-west1-b**.

### A5 — OS de la VM ✅ RESUELTO
- **Ubuntu 22.04 LTS** (`ubuntu-os-cloud/ubuntu-2204-lts`).

### A6 — Sandboxing ✅ RESUELTO
- **Sin Docker adicional.** La VM es el sandbox. Hermes corre con backend `local` directamente en la VM.

### A7 — Gestión de repos en disco ✅ RESUELTO
- Máximo ~3 repos simultáneos. 30 GB es suficiente para empezar.
- Directorio base: `/workspace/<repo>`.
- Los clones persisten entre tareas (no se borran tras cada PR).

### A8 — Puertos ✅ RESUELTO
- Proxy LiteLLM: **8645** (default de Hermes proxy).
- Gateway de webhooks (GitHub): **8644** (puerto custom, abre en firewall GCP).
- Dashboard Hermes: **9119** (solo acceso local, no expuesto al exterior).

### A9 — Secretos ✅ RESUELTO
- **GCP Secret Manager** (repo será público, es un template deployable por cualquiera).
- Secretos a gestionar: `github-pat`, `github-webhook-secret`.
- SA necesita rol adicional: `roles/secretmanager.secretAccessor`.
- `startup.sh` fetchea los secretos via `gcloud secrets versions access latest --secret=<name>` e inyecta en `.env` de Hermes al arrancar.

### A10 — Concurrencia ✅ RESUELTO
- **Secuencial**: una tarea a la vez. El gateway encola los webhooks entrantes.

---

## 🟡 DETALLES TÉCNICOS (se pueden asumir con defaults razonables, pero mejor confirmar)

### D1 — Versión de Python y pip para LiteLLM
- ¿Python 3.11? ¿3.12?

### D2 — Nombre de la Service Account
- ¿Convención de naming? ej: `hermes-agent-sa@<project>.iam.gserviceaccount.com`

### D3 — IP estática: ¿nombre del recurso?
- ¿Alguna convención de naming para los recursos GCP?

### D4 — Firewall SSH ✅ RESUELTO
- Variable Terraform `ssh_allowed_cidr`, default `0.0.0.0/0`.
- El usuario que deploya puede restringirlo a su IP en `terraform.tfvars`.

### D5 — Naming de ramas ✅ RESUELTO
- Patrón: `<agent_name>/issue-<number>/<slug>` → ej: `lucas/issue-42/fix-login-bug`
- `agent_name` es una variable configurable (en `terraform.tfvars` y en el system prompt de Hermes).

### D6 — Comentario en Issue al terminar ✅ RESUELTO
- Sí. Al abrir el PR, el agente comenta en el Issue original con el link al PR.

---

## ✅ LO QUE SÍ ESTÁ CLARO

- VM: e2-standard-2, 30 GB disco, IP pública estática
- Red: VPC default, firewall SSH (22) + webhook (8644)
- Auth GCP: Service Account con roles/aiplatform.user (sin API keys en texto)
- Proxy: LiteLLM como systemd service, traducción OpenAI → Vertex AI
- Flujo Git: nunca push a main, siempre branch → PR vía `gh pr create`
- IDE: Remote SSH con Cursor/VSCode documentado

---

## PREGUNTAS RESUELTAS

_(se irán moviendo aquí a medida que el usuario responda)_

---

## DECISIONES TOMADAS

_(arquitectura confirmada)_
