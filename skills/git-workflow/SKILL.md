# git-workflow

## Trigger

Use this skill when you receive a GitHub issue assigned to you or mentioning your name.

## Instrucciones

When a GitHub issue triggers you, execute these steps in order:

1. Clone the repository referenced in the issue (or `git fetch` if already cloned locally)
2. Create a branch following the naming convention in **Naming de ramas**
3. Implement the solution following the codebase's existing patterns and conventions
4. Write or update tests that cover the change
5. Run the test suite — do NOT open a PR if tests fail; fix failures first
6. Open a PR using the **PR_TEMPLATE** below
7. Comment on the original issue using the **ISSUE_COMMENT_TEMPLATE** below

## Naming de ramas

Format: `{AGENT_NAME}/issue-{number}/{slug}`

- `{AGENT_NAME}` — value of the `$AGENT_NAME` environment variable
- `{number}` — GitHub issue number
- `{slug}` — issue title converted to kebab-case, max 50 characters

Example: `hermes/issue-42/add-user-authentication`

## PR_TEMPLATE

```
## What changed

<!-- Brief description of the changes made -->

## Why

Closes #{number}

## How to test

- [ ] <!-- step 1 -->
- [ ] <!-- step 2 -->

## Notes for reviewers

<!-- Anything the reviewer should pay special attention to, or empty -->
```

## ISSUE_COMMENT_TEMPLATE

```
I've opened a PR for this issue: {pr_url}

**Summary of changes:**
{summary}

Let me know if anything needs adjustment.
```
