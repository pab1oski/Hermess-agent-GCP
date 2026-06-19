# Implementation traceability — cursor_ssh_connection

## Requirement → test/verification map

| Requirement | Coverage | Location |
|-------------|----------|----------|
| R1: generate-ssh-config.sh fetches IP from `terraform output -raw vm_ip` and generates a valid SSH config block | T5 (manual, VM required) + shellcheck pass (T4) | `scripts/generate-ssh-config.sh` |
| R2: Block includes Host hermes-agent, HostName, User ubuntu, IdentityFile ~/.ssh/id_rsa, StrictHostKeyChecking no | Code inspection + T5 (manual) | `scripts/generate-ssh-config.sh` lines 9-14 |
| R3: docs/cursor-ssh-guide.md covers Remote-SSH install, SSH config, connection, ~/.hermes/ editing, skills, MCPs | File written with 7 required sections | `docs/cursor-ssh-guide.md` |
| R4: Operator with no SSH knowledge can follow guide and connect | Guide written with step-by-step instructions including troubleshooting | `docs/cursor-ssh-guide.md` |
| R5: Script detects existing Host hermes-agent and updates instead of duplicating | Code inspection — while-read loop skips existing block and rewrites config | `scripts/generate-ssh-config.sh` lines 19-34 |

## Notes

- T5 (live VM connection test) requires a deployed VM. This is a manual verification step; no automated test is possible without active GCP infrastructure.
- shellcheck passes with no errors or warnings (verified with shellcheck-py 0.11.0.1).
- Script is idempotent: creates ~/.ssh/ and ~/.ssh/config if missing, sets correct permissions (700/600).
