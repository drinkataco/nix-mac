---
name: start
description: >
  Start work on a Jira ticket: fetch it, create a type-prefixed branch (fix/PROJ-123,
  feature/PROJ-123, …), and summarise the acceptance criteria to work against. Invoke
  with a ticket key, e.g. "/start PROJ-123", "start on PROJ-123", or "begin PROJ-123".
model: sonnet
argument-hint: "[TICKET-KEY]"
allowed-tools:
  - "Bash(git fetch:*)"
  - "Bash(git pull:*)"
  - "Bash(git checkout:*)"
  - "Bash(git switch:*)"
  - "Bash(git branch:*)"
  - "Bash(git status:*)"
---

Set me up to work on a Jira ticket. The ticket key is the argument (e.g. `PROJ-123`); if I didn't give one, ask for it.

## Steps
1. **Fetch the ticket** — use the Atlassian MCP tools to get the issue: summary, description, issue type, status, acceptance criteria.
2. **Pick the branch prefix** from the issue type:
   - **Bug** → `fix/`
   - **Story / New Feature / Feature / Improvement / Epic** → `feature/`
   - **Chore / Spike / anything else** → `chore/`
   If the type is unclear, tell me your best guess and let me override.
3. **Create the branch** — `<prefix><TICKET>-<short-slug>`, where the slug is 2–4 kebab-case words from the summary (e.g. `feature/PROJ-123-oauth-login`). Keep the ticket key uppercase and intact so `/pr` and `/commit` can find it. Branch **from an up-to-date default branch**: check out the repo's default branch (`main`/`master`, per `origin/HEAD` — don't assume), `git pull` to bring it up to date, then create the new branch from it. If I already have uncommitted work, stop and ask before switching.
4. **Brief me** — print a short summary: the ticket title, a one-line of what it's asking for, and the acceptance criteria as a checklist I can work against. Note anything ambiguous or underspecified in the ticket.

## Rules
- Don't start coding — this just sets up the branch and orients me. Wait for my direction on the actual work.
- Never move the ticket's status or comment on it unless I ask.
- If a branch for this ticket already exists, check it out instead of creating a duplicate.
- If the MCP fetch fails or the ticket doesn't exist, say so and stop — don't guess the branch from the key alone unless I tell you to.

## Output
The branch name, the ticket title, and the acceptance-criteria checklist. No preamble.
