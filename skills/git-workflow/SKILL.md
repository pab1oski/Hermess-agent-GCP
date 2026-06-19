# git-workflow

## Trigger

Use this skill when you receive a GitHub issue assigned to you or mentioning your name.

---

## PHASE 1 — ANALYZE

Before writing a single line of code, understand the problem.

### 1.1 — Read the issue

Extract from the issue:
- What is broken or missing
- What the expected behavior is
- Any constraints, edge cases, or acceptance criteria mentioned

### 1.2 — Clone the repo

```
gh repo clone <owner>/<repo> /tmp/hermes-repos/<repo>
```

If already cloned:
```
git -C /tmp/hermes-repos/<repo> fetch origin
git -C /tmp/hermes-repos/<repo> checkout main
git -C /tmp/hermes-repos/<repo> pull
```

### 1.3 — Read the codebase

Before creating the spec, read:
- Top-level structure (list files/dirs)
- Entry points relevant to the issue
- Existing tests for the affected area
- Any `README`, `CONTRIBUTING`, or `docs/` files that define conventions

### 1.4 — Create the working spec

Create a directory at `/tmp/hermes-work/<repo>/<issue-number>/` with these 3 files:

**`requirements.md`** — list of acceptance criteria. Each item starts with `R<n>:`. Example:
```
R1: The endpoint returns 404 when the resource does not exist
R2: Error response includes a human-readable message
R3: Existing passing tests remain green
```

**`design.md`** — your implementation approach:
- Which files will change and why
- Pattern or abstraction to use
- Edge cases to handle
- What NOT to change (scope boundary)

**`tasks.md`** — ordered checklist of concrete actions:
```
- [ ] T1: Add null check to getUserById in src/users/service.ts
- [ ] T2: Write unit test for null case in tests/users/service.test.ts
- [ ] T3: Update error handler to return 404 with message
- [ ] T4: Write integration test for 404 response
```

Do NOT proceed to Phase 2 until all 3 files exist and tasks.md has at least one task.

### 1.5 — Create the branch

```
git -C /tmp/hermes-repos/<repo> checkout -b ${AGENT_NAME}/issue-<number>/<slug>
```

Slug = issue title in kebab-case, max 50 characters.
Example: `hermes/issue-42/fix-null-pointer-in-user-service`

---

## PHASE 2 — IMPLEMENT

Work through tasks.md in order. For each `- [ ] Tn`:

1. Read the task description carefully
2. Implement the change in the codebase
3. Write or update the test that covers it
4. Run the test suite:
   ```
   cd /tmp/hermes-repos/<repo> && <test command>
   ```
5. If tests fail: fix them before marking the task done
6. Mark the task complete in tasks.md: change `- [ ] Tn` to `- [x] Tn`
7. Commit:
   ```
   git -C /tmp/hermes-repos/<repo> add -p
   git -C /tmp/hermes-repos/<repo> commit -m "feat: <what this task does>"
   ```

Do NOT move to Phase 3 until every task in tasks.md is `[x]`.

---

## PHASE 3 — VERIFY

### 3.1 — Full test suite

```
cd /tmp/hermes-repos/<repo> && <test command>
```

Must be 100% green. If anything fails: return to Phase 2.

### 3.2 — Diff review

```
git -C /tmp/hermes-repos/<repo> diff main...HEAD
```

Check:
- No debug statements, `console.log`, `print()`, or commented-out code
- No hardcoded secrets or credentials
- Every changed line directly serves the issue
- No unrelated changes (scope creep)

### 3.3 — Requirements traceability

Open `/tmp/hermes-work/<repo>/<issue-number>/requirements.md`.
For each `R<n>`, confirm there is a test or code change that satisfies it.
If any requirement is unmet: return to Phase 2.

### 3.4 — Commit hygiene

```
git -C /tmp/hermes-repos/<repo> log main..HEAD --oneline
```

Every commit must follow Conventional Commits:
`feat:`, `fix:`, `test:`, `refactor:`, `docs:`, `chore:`

No commit should say "WIP", "temp", "fix fix", or similar.
If a commit message is wrong: fix it with `git commit --amend` or interactive rebase.

---

## PHASE 4 — SHIP

### 4.1 — Cleanup working files

```
rm -rf /tmp/hermes-work/<repo>/<issue-number>/
```

These files are planning artifacts. They must not appear in the PR.

### 4.2 — Open the PR

Use this template:

```
gh pr create \
  --title "<concise summary of what changed>" \
  --body "$(cat <<'EOF'
## What changed

<!-- Concrete description of the changes -->

## Why

Closes #<issue-number>

## How to test

- [ ] <step 1>
- [ ] <step 2>

## Notes for reviewers

<!-- Anything the reviewer should pay attention to, or leave empty -->
EOF
)"
```

### 4.3 — Comment on the issue

```
gh issue comment <issue-number> --repo <owner>/<repo> --body "$(cat <<'EOF'
I've opened a PR for this issue: <pr_url>

**Summary of changes:**
<2-3 sentence summary of what was done and why>

Let me know if anything needs adjustment.
EOF
)"
```

---

## Branch naming convention

Format: `{AGENT_NAME}/issue-{number}/{slug}`

- `{AGENT_NAME}` — value of the `$AGENT_NAME` environment variable
- `{number}` — GitHub issue number
- `{slug}` — issue title in kebab-case, max 50 characters

Example: `hermes/issue-42/add-user-authentication`
