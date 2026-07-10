---
name: commit
description: >
  Stage and commit the current work following my git conventions. Handles branch-first
  on master/main, writes an imperative why-not-what message, and never adds trailers or
  pushes. Invoke when I say "commit", "commit this", or "/commit".
model: sonnet
allowed-tools:
  - "Bash(git status:*)"
  - "Bash(git diff:*)"
  - "Bash(git log:*)"
  - "Bash(git add:*)"
  - "Bash(git commit:*)"
  - "Bash(git branch:*)"
  - "Bash(git checkout:*)"
  - "Bash(git switch:*)"
---

Commit the current changes following my conventions. Do the work; don't ask for confirmation on the mechanics.

## Steps
1. **Inspect** — `git status` and `git diff` (plus `git diff --staged`) to see what's actually changing. If nothing is staged or modified, say so and stop.
2. **Branch-first** — if the current branch is `master` or `main` and this is a non-trivial change, create a branch before committing. Name it with the same convention as `/start`: a type prefix (`fix/`, `feature/`, `chore/`) + a short kebab-case slug — and include the Jira ticket key if one is obvious from the change (e.g. `feature/PROJ-123-oauth-login`, else `chore/tidy-commit-skill`). Skip for trivial edits (typo, one-liner) unless I ask.
3. **Stage** — stage the relevant files. Don't blindly `git add -A` if unrelated changes are present; stage what belongs to this commit and mention anything you left out.
4. **Message** — write it factual and imperative, explaining *why* not just *what*. Subject line in imperative mood, ~50 chars; add a body when the reasoning isn't obvious from the subject. Match the style of recent `git log`.
5. **Commit** — commit. Do **not** push unless I explicitly asked in this request.

## Rules
- Never add `Co-Authored-By` or any advertising/tool trailers.
- Never `git push`, force-push, or touch the remote unless I said so.
- If the diff looks like it should be split into more than one commit, say so and propose the split rather than lumping it together.
- If the change is substantive and hasn't been reviewed, offer to run `code-reviewer` first — but don't block on it.

## Output
The branch (if you created one), the commit subject, and a one-line note of anything you deliberately left unstaged. No preamble.
