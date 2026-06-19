# Review — features 9 (cursor_ssh_connection) and 10 (documentation)

---

## Feature 9 — cursor_ssh_connection

**Veredicto: APPROVED**

### Trazabilidad requirements ↔ tests / verificación

- R1: [x] `scripts/generate-ssh-config.sh` line 7 — `terraform output -raw vm_ip`. Confirmed present.
- R2: [x] `scripts/generate-ssh-config.sh` lines 9–13 — all five fields present: `Host hermes-agent`, `HostName`, `User ubuntu`, `IdentityFile ~/.ssh/id_rsa`, `StrictHostKeyChecking no`.
- R3: [x] `docs/cursor-ssh-guide.md` — 7 sections cover: Remote-SSH install (section 1, lines 12–15), SSH config generation (section 2), Cursor connection (section 3), `~/.hermes/` editing (section 4), skills (section 5), MCPs (section 6), troubleshooting (section 7).
- R4: [x] Guide written for non-SSH-experts: step-by-step Cursor UI instructions (section 3 lines 56–66), explicit file paths, integrated-terminal commands, and a dedicated troubleshooting section with 5 common failure modes.
- R5: [x] `scripts/generate-ssh-config.sh` lines 26–53 — detects existing `Host hermes-agent` via `grep -q "^Host hermes-agent$"`, then strips the old block with a line-by-line loop and appends the updated block.

### Tasks completas

- T1: [x]
- T2: [x]
- T3: [x]
- T4: [x]
- T5: [ ] — Justified in `progress/impl_cursor_ssh_connection.md` line 15: live VM required; no automated test is possible without active GCP infrastructure.

### Checkpoints (scope: Feature 9)

- C1: [x] Files exist; `./init.sh` exits 0.
- C2: [x] Feature is `done` in `feature_list.json`; no active in_progress for this feature.
- C3: [x] No src/ changes; script is pure bash infrastructure tooling.
- C4: [x] No tests/ changes expected for a shell-script + doc feature; justification documented.
- C5: [x] `progress/impl_cursor_ssh_connection.md` is present and complete.

---

## Feature 10 — documentation

**Veredicto: CHANGES_REQUESTED**

### Trazabilidad requirements ↔ tests / verificación

- R1: [ ] README quick start has **7 steps**, not 6 as required. More critically, the required steps "SSH to the VM" and "run provision.sh" are absent as explicit user actions — they are folded into an automated boot process (step 5). R1 explicitly requires step (3) SSH to VM and step (4) run provision.sh as user-facing steps. The current README skips them. Also, step 2 in the README is "Configure variables" (not `terraform init + apply`), pushing terraform to step 3 and breaking the required sequence.
- R2: [x] `docs/architecture.md` — sections GitHub Layer (lines 31–37), GCP Layer (lines 39–47), VM Layer (lines 55–64), Vertex AI Layer (lines 66–73) plus the data-flow diagram (lines 8–26). All three required layers (GCP, VM, GitHub) are present.
- R3: [ ] `docs/conventions.md` line 9 defines naming as `{agent_name}-{resource_type}` (two-part, e.g. `hermess-vm`). Spec R3 requires the `{project}-{resource}-{env}` pattern (three-part, with environment suffix). The `{env}` component is entirely absent from the naming convention.
- R4: [x] `docs/verification.md` — 5 ordered steps from `terraform validate` (Step 1) through first automatic PR (Step 5), plus diagnostics section.
- R5: [x] README lines 7–17 contain the ASCII architecture diagram.
- R6: [ ] README prerequisites (lines 23–29) list gcloud CLI and Terraform >= 1.5. **gh CLI** and **shellcheck** are not listed with minimum versions, as required by R6.

### Tasks completas

- T1: [x] (README was pre-existing and not modified — noted in impl_documentation.md; however R1 and R6 gaps exist in the pre-existing file and are not flagged)
- T2: [x]
- T3: [x]
- T4: [x]
- T5: [ ] — `verification.md` references `./scripts/test-e2e.sh` and `./scripts/test-e2e-full.sh`. No note in impl_documentation.md confirms these script paths were validated against the actual scripts from Feature 8.

### Checkpoints (scope: Feature 10)

- C1: [x] All base files exist; `./init.sh` exits 0.
- C2: [ ] Feature 10 is still `in_progress` in `feature_list.json` — this is consistent with active work, but means the feature is not closed.
- C3: [x] No src/ changes; docs-only feature.
- C4: [x] No tests/ expected for a docs-only feature.
- C5: [ ] `progress/current.md` still shows "En progreso" — session not closed.

### Cambios requeridos

1. **R1 — README quick start step sequence**: Add explicit steps (3) `ssh ubuntu@<vm-ip>` and (4) `bash /opt/hermes-deploy/scripts/provision.sh` so the 6-step sequence from the spec is present. Currently both actions are implicit in "Wait for VM provisioning" (step 5).

2. **R3 — Naming convention**: `docs/conventions.md` defines `{agent_name}-{resource_type}` but R3 requires `{project}-{resource}-{env}`. Either add the `{env}` suffix to the convention (and update examples on lines 12–22) or update the spec if the actual project pattern intentionally omits environment. Resolution must be documented.

3. **R6 — Prerequisites missing gh CLI and shellcheck**: README prerequisites section must list `gh CLI` and `shellcheck` with minimum versions (or "any recent version" if no minimum is defined), matching R6.

4. **T5 — Script path validation**: Confirm that the paths `./scripts/test-e2e.sh` and `./scripts/test-e2e-full.sh` in `docs/verification.md` match the actual files on disk. Document the result in `progress/impl_documentation.md`.
