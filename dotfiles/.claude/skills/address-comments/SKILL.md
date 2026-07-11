---
name: address-comments
description: >
  Pull review comments on a PR and work through them one by one — fixing what's
  actionable, asking about the rest. Defaults to the current branch's PR. Can
  also take a PR (number/URL) or Jira key; if that PR isn't on my current
  branch, works in an isolated worktree so my in-progress work stays intact.
  Invoke when I say "address the PR comments", "handle the review feedback on
  X", or "/address-comments".
argument-hint: "[PR number/URL | JIRA-KEY]"
effort: high
allowed-tools:
  - "Bash(git status:*)"
  - "Bash(git diff:*)"
  - "Bash(git log:*)"
  - "Bash(git fetch:*)"
  - "Bash(git checkout:*)"
  - "Bash(git switch:*)"
  - "Bash(git branch:*)"
  - "Bash(git worktree:*)"
  - "Bash(gh pr view:*)"
  - "Bash(gh pr list:*)"
  - "Bash(gh pr checkout:*)"
  - "Bash(gh pr diff:*)"
  - "Bash(gh api:*)"
  - "Bash(gh search prs:*)"
  - "Bash(gh repo view:*)"
---

Work through the review feedback on a PR. Goal: every comment ends up resolved, ready-to-fix, or clearly answered.

## Steps

### 1. Resolve the target PR
Same resolution rules as `/review-pr`:
- **No argument** → the PR for the current branch (`gh pr view --json number,url,title,headRefName,headRepository,baseRefName`). If none, say so and stop.
- **Bare number** (`72`), **URL**, or `owner/repo#N` → that PR.
- **Jira key** (`ABC-123`) → find linked PR(s) via the Atlassian MCP dev data first, falling back to `gh search prs "ABC-123"`. A ticket often spans multiple repos.
  - Exactly one open PR → use it.
  - Several → list them and let me pick with **`AskUserQuestion`**, one option per PR (repo + title + state).
- If nothing resolves, say so and stop — don't guess.

### 2. Isolate if needed
Compare the PR's `headRefName` + repo to my current branch and repo (`git branch --show-current`, `gh repo view --json nameWithOwner`).
- **Same branch, same repo, clean tree** → work in place.
- **Different branch, different repo, or dirty tree** → create a **git worktree** so my in-progress work stays intact:
  ```
  gh pr checkout <n> --repo <owner/repo> --branch pr-<n>
  git worktree add ../<repo>-pr-<n> pr-<n>
  ```
  (or fetch `pull/<n>/head` into a branch and `git worktree add` from it). Tell me the worktree path. Everything below happens in that worktree.

### 3. Collect every comment thread
- `gh pr view --comments` for top-level review/issue comments.
- `gh api repos/{owner}/{repo}/pulls/{number}/comments` for inline code review comments (with `file:line`).
- `gh api repos/{owner}/{repo}/pulls/{number}/reviews` for review submissions with bodies.
- Skip threads already **resolved**, and pure approvals/"LGTM" with no content. Note the author and `file:line` for each remaining thread.

### 4. Triage each comment
- **I'll fix it** — concrete, actionable (bug, rename, missing test, simplification). Make the edit.
- **Needs your call** — design question, trade-off, ambiguity. Don't guess — ask me, quoting the comment.
- **Discuss / push back** — where the reviewer may be wrong or it's out of scope. Flag it with my reasoning.

### 5. Make the fixes & verify
Apply the "I'll fix it" changes. Group related ones. After editing, **verify**: run the relevant tests or build via the project's tooling. Say so honestly if you couldn't (e.g. a fresh worktree lacks `node_modules` and installing is out of scope).

### 6. Report back
A per-comment rundown grouped by the three buckets, each with `file:line` and outcome. Then a one-line verification note and — if you're in a worktree — the path so I can `/commit` there.

## Rules
- Don't commit, push, or reply to comments on GitHub. Fixes stay staged/unstaged for me — leave `/commit` and any GitHub replies to my say-so.
- Address the substance of each comment, not just the literal wording. If a comment reveals a pattern, fix the other instances too and note it.
- Don't silently drop a comment. Every thread lands in one of the three buckets.
- If a requested change looks wrong or risky, don't just make it — raise it under "Discuss / push back".
- When working in a worktree, never touch my original working tree or current branch.

## Output
The resolved PR (repo + number + title), the workspace (in-place or worktree path), a per-comment list grouped by the three buckets with `file:line` and outcome, then a one-line verification note. No preamble.
