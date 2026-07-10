---
name: pr
description: >
  Open a GitHub PR for the current branch following my conventions. Pushes the branch,
  writes an imperative why-not-what title and body from the commits, and never adds
  trailers. Invoke when I say "open a PR", "raise a PR", or "/pr".
allowed-tools:
  - "Bash(git status:*)"
  - "Bash(git log:*)"
  - "Bash(git diff:*)"
  - "Bash(git branch:*)"
  - "Bash(git push:*)"
  - "Bash(gh pr create:*)"
  - "Bash(gh pr view:*)"
  - "Bash(gh pr list:*)"
  - "Bash(gh repo view:*)"
---

Open a pull request for the current branch with `gh`. Do the work; don't ask for confirmation on the mechanics.

## Steps
1. **Check state** — `git status` and `git branch --show-current`. If I'm on `master`/`main`, stop and tell me: there's nothing to PR from the default branch (offer to branch + move the commits if that's clearly what I meant).
2. **Sync** — make sure my commits are committed (nothing important left unstaged; if there is, say so). Push the branch with `-u` if it has no upstream.
3. **Determine base** — default to the repo's default branch (`gh repo view --json defaultBranchRef` or the `origin/HEAD` ref). Don't assume `main` vs `master`.
4. **Find a PR template** — look for `.github/PULL_REQUEST_TEMPLATE.md`, `.github/pull_request_template.md`, `docs/`, the repo root, or a `.github/PULL_REQUEST_TEMPLATE/` directory (may hold several). If one exists, use it as the body scaffold and fill in the free-text sections from the change. Handle any **checklist** items (`- [ ]`) as in the next step.
5. **Work the checklist** — for each checklist item in the template, judge from the diff/commits/repo whether it's already satisfied, then sort it into one of:
   - **Done** — clearly satisfied by the change (e.g. "tests added" and the diff adds tests). Tick it (`- [x]`) and note why.
   - **I can do it** — actionable by me right now (e.g. "update the changelog", "add a doc note"). Leave it unticked, and **ask whether I should do it** before opening the PR.
   - **You verify** — needs your judgement or something I can't confirm (e.g. "tested on a device", "reviewed with design", "no secrets committed"). Leave it unticked and **ask me to confirm** it.
   Present these grouped under those three headings and wait for my answer before creating the PR, unless every item is already Done.
6. **Draft title + body** — from the commits on this branch (`git log <base>..HEAD`):
   - **Title**: imperative, concise, explains the change — not just a restatement of the diff. **If there's a Jira ticket number, always include it.** Find it in the branch name (e.g. `PROJ-123-add-thing`), then the commit messages; use the format the repo's existing PR titles use (e.g. `PROJ-123: <summary>` or `[PROJ-123] <summary>` — check `gh pr list` if unsure). If no ticket number is anywhere, don't invent one.
   - **Body**: fill the template if there is one; otherwise a short *why* summary then a bullet list of the notable changes if there's more than one. Keep it factual. Include a Test plan / verification line noting what I ran (or "not yet verified" if I didn't).
7. **Create** — `gh pr create --base <base> --title ... --body ...`. Return the PR URL.

## Rules
- Never add `Co-Authored-By` or advertising/tool trailers to the title or body.
- Don't open the PR as a draft unless I ask.
- Don't merge, don't enable auto-merge, don't touch anything after creation unless I say so.
- If the branch has no commits ahead of base, stop — there's nothing to open.
- If a PR already exists for this branch, show me its URL instead of creating a duplicate.
- If the change is substantive and unreviewed, offer to run `code-reviewer` first — but don't block on it.

## Output
The PR URL, its title, and the base branch. Flag anything left unstaged or unverified. No preamble.
