---
name: start
description: >
  Start work on a piece of work: with a Jira key, fetch the ticket; with a free-text
  description (or nothing), scope it with a couple of quick questions instead. Either way,
  create a type-prefixed branch and orient me. Invoke with a ticket key ("/start PROJ-123")
  or a description ("/start dark-mode toggle", "start on the login bug").
model: sonnet
argument-hint: "[TICKET-KEY | description]"
allowed-tools:
  - "Bash(git fetch:*)"
  - "Bash(git pull:*)"
  - "Bash(git checkout:*)"
  - "Bash(git switch:*)"
  - "Bash(git branch:*)"
  - "Bash(git status:*)"
---

Set me up to work on something, then stop. Two modes, chosen from the argument.

## Choose the mode
- If the argument matches a **Jira key** (`ABC-123` — uppercase project code, dash, number), use **Ticket mode**.
- Otherwise — free text like `dark-mode-toggle`, or no argument at all — use **Ticketless mode**.

## Ticket mode
1. **Fetch the ticket** — use the Atlassian MCP tools to get the issue: summary, description, issue type, status, acceptance criteria. If the fetch fails or the ticket doesn't exist, say so and stop — don't guess the branch from the key alone unless I tell you to.
2. **Scope it if the ticket is thin** — tickets are often vague. If the type is unclear, there are no acceptance criteria, or the summary doesn't actually say what's wanted, fill the gaps with the **Scope it** step below (only ask about what's genuinely missing — don't re-ask what the ticket already answers). If the ticket is clear, skip straight to the branch.
3. **Pick the branch prefix** from the issue type (see the shared table below).
4. **Create the branch** — `<prefix><TICKET>-<short-slug>` (e.g. `feature/PROJ-123-oauth-login`). Keep the ticket key uppercase and intact so `/pr` and `/commit` can find it.
5. **Brief me** — ticket title, a one-line of what it's asking for, and the acceptance criteria (from the ticket, plus anything we clarified) as a checklist.
6. **Offer to move the ticket** — ask whether I want it transitioned to "In Progress" (or the equivalent next status). Only transition it if I say yes; never comment on the ticket unless I ask.

## Ticketless mode
1. **Scope it** — always run the **Scope it** step below to establish the goal and type.
2. **Pick the branch prefix** from the chosen *Type* (see the shared table below).
3. **Create the branch** — `<prefix><short-slug>`, slug being 2–4 kebab-case words from the goal (e.g. `feature/dark-mode-toggle`). No ticket key.
4. **Brief me** — restate the goal in a line, note the type, and list the definition-of-done as a checklist.

## Scope it (shared)
Gather the shape of the work with the **structured question tool (`AskUserQuestion`)**, so I pick from suggested options rather than typing answers to a prose list. Ask each open point as its own question, and always propose your own best-guess suggestions (each question also allows free-text "Other"). Seed the suggestions from whatever context you have — the free text I gave, the ticket's summary/description, and your read of the repo. Cover only what's still unclear:
- **Goal** — what are we building/fixing? Offer a few plausible interpretations as options.
- **Type** — `fix` / `feature` / `chore`, your best guess first (recommended).

Infer the **definition of done** yourself from the resolved goal and put it in the brief for me to correct — don't make it a question, since it depends on the goal.

## Branch prefix (both modes)
- **Bug / a fix** → `fix/`
- **Story / Feature / Improvement / Epic / new capability** → `feature/`
- **Chore / Spike / anything else** → `chore/`
If the type is unclear, tell me your best guess and let me override.

## Creating the branch (both modes)
Branch **from an up-to-date default branch**: check out the repo's default branch (`main`/`master`, per `origin/HEAD` — don't assume), `git pull`, then create the new branch from it. If I already have uncommitted work, stop and ask before switching. If a branch for this work already exists, check it out instead of creating a duplicate.

## Rules
- Don't start coding — this just sets up the branch and orients me. Wait for my direction on the actual work.
- In Ticket mode, ask before transitioning the ticket's status, and never comment on it unless I ask.

## Output
The branch name, the goal/title, and the definition-of-done (or acceptance-criteria) checklist. No preamble.
