# Connecting Cursor (or VSCode) to the Hermes Agent VM via Remote SSH

This guide lets you browse, edit, and manage files on the VM directly from
Cursor or VSCode as if they were local files. No prior SSH knowledge required.

---

## 1. Prerequisites

Before you start, make sure you have:

- **Cursor** (https://cursor.sh) or **VSCode** (https://code.visualstudio.com) installed locally.
- The **Remote - SSH** extension installed in your editor.
  - Cursor: open the Extensions panel (`Ctrl+Shift+X` / `Cmd+Shift+X`), search for `Remote - SSH`, and install the extension published by Microsoft.
  - VSCode: same steps.
- An **SSH key pair** already created on your local machine. Run `ls ~/.ssh/id_rsa` to check. If the file is missing, create one:
  ```bash
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
  ```
- The **public key** (`~/.ssh/id_rsa.pub`) added to the VM. This is handled automatically by Terraform via the startup script — no manual step needed if you deployed with this repo.
- **Terraform** CLI installed and the infrastructure already deployed (`terraform apply` completed successfully inside the `terraform/` directory).

---

## 2. Generate the SSH config

From the root of this repository, run:

```bash
bash scripts/generate-ssh-config.sh
```

The script:
1. Reads the VM's public IP from `terraform output -raw vm_ip`.
2. Writes (or updates) a `Host hermes-agent` block in `~/.ssh/config`.
3. Is idempotent — safe to run again after `terraform apply` updates the IP.

Expected output:

```
SSH config updated. Connect with: ssh hermes-agent
```

Verify the connection works before opening Cursor:

```bash
ssh hermes-agent "echo OK"
```

If you see `OK`, you are ready.

---

## 3. Connect from Cursor

1. Open Cursor.
2. Press `Ctrl+Shift+P` (`Cmd+Shift+P` on macOS) to open the Command Palette.
3. Type **Remote-SSH: Connect to Host** and select it.
4. Choose **hermes-agent** from the list (it comes from your `~/.ssh/config`).
5. A new Cursor window opens. The first connection takes ~30 seconds while the Remote SSH server installs on the VM.
6. Once connected, the bottom-left corner of Cursor shows **SSH: hermes-agent**.

Alternatively, use the **Remote Explorer** sidebar:
- Click the Remote Explorer icon in the Activity Bar (or press `Ctrl+Shift+P` → **Remote Explorer: Focus on SSH Targets View**).
- Right-click **hermes-agent** → **Connect to Host in New Window**.

---

## 4. Edit the agent configuration

Once connected, open a folder on the VM:

1. Press `Ctrl+K Ctrl+O` (`Cmd+K Cmd+O`) → **Open Folder**.
2. Type `/home/ubuntu/.hermes/` and press **OK**.

You now have full access to:

| Path | Purpose |
|------|---------|
| `/home/ubuntu/.hermes/config.yaml` | Main Hermes Agent configuration |
| `/home/ubuntu/.hermes/SOUL.md` | Agent identity and workflow |
| `/home/ubuntu/.hermes/.env` | Secrets (API keys, tokens) — `chmod 600` |
| `/home/ubuntu/.hermes/skills/` | Installed custom skills |

Edit any file and save. Changes take effect the next time Hermes runs or reloads its config. To reload without restarting the service:

```bash
# In the Cursor integrated terminal (Ctrl+`)
hermes config reload
```

---

## 5. Add custom skills

A skill is a directory inside `~/.hermes/skills/` containing a `SKILL.md` file.

To create a new skill from Cursor:

1. In the Explorer panel, navigate to `/home/ubuntu/.hermes/skills/`.
2. Right-click → **New Folder** → name it after your skill (e.g. `code-review`).
3. Right-click the new folder → **New File** → `SKILL.md`.
4. Write the skill instructions in `SKILL.md` following the format used by the existing `git-workflow` skill.

To verify the skill is recognized:

```bash
# In the integrated terminal
hermes skills list
```

The new skill name should appear in the output.

---

## 6. Configure MCPs

MCPs (Model Context Protocol servers) are defined in `~/.hermes/config.yaml`
under the `mcp_servers` key.

1. Open `/home/ubuntu/.hermes/config.yaml` in Cursor.
2. Locate the `mcp_servers` section. Example structure:

```yaml
mcp_servers:
  - name: filesystem
    command: npx
    args: ["-y", "@modelcontextprotocol/server-filesystem", "/home/ubuntu"]
  - name: github
    command: npx
    args: ["-y", "@modelcontextprotocol/server-github"]
    env:
      GITHUB_TOKEN: "${GITHUB_TOKEN}"
```

3. Add or modify entries as needed.
4. Save the file, then restart Hermes to apply:

```bash
sudo systemctl restart hermes
sudo systemctl status hermes
```

---

## 7. Troubleshooting

### `ssh hermes-agent` times out or refuses connection

- Confirm the VM is running: `gcloud compute instances list`.
- Check the firewall allows port 22: in the GCP Console → VPC network → Firewall, look for a rule allowing TCP 22 from your IP.
- Re-run `bash scripts/generate-ssh-config.sh` — the IP may have changed after a restart (static IP is assigned by Terraform, but verify `terraform output vm_ip`).

### "Host key verification failed"

The VM was recreated and its host key changed. Remove the stale entry:

```bash
ssh-keygen -R hermes-agent
```

Then reconnect.

### Cursor shows "Could not establish connection" after a long wait

- Check that `sshd` is running on the VM: `ssh hermes-agent "sudo systemctl status ssh"`.
- Increase the connection timeout in Cursor settings: search for `remote.SSH.connectTimeout` and set it to `60`.

### Permission denied (publickey)

Your public key is not authorized on the VM. Copy it manually:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@"$(cd terraform && terraform output -raw vm_ip)"
```

### Changes to `.hermes/config.yaml` don't take effect

Hermes reads its config on startup. Restart the service after editing:

```bash
ssh hermes-agent "sudo systemctl restart hermes"
```

### Cursor terminal shows a different home directory than expected

The integrated terminal connects as user `ubuntu`. Confirm with `echo $HOME` — it should print `/home/ubuntu`.
