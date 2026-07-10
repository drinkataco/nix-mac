---
name: address-comments
description: >
  Pull the review comments on the current branch's PR and work through them one by one —
  fixing what's actionable, asking me about the rest. Invoke when I say "address the PR
  comments", "handle the review feedback", or "/address-comments".
effort: high
allowed-tools:
  - "Bash(git status:*)"
  - "Bash(git diff:*)"
  - "Bash(git log:*)"
  - "Bash(gh pr view:*)"
  - "Bash(gh api:*)"
---

Work through the review feedback on the current branch's PR. The goal is to resolve every comment or have a clear answer for it.

## Steps
1. **Find the PR** — for the current branch, via `gh pr view --json number,url,title` and its comments: `gh pr view --comments` plus the inline review threads (`gh api repos/{owner}/{repo}/pulls/{number}/comments`). If there's no PR for this branch, say so and stop.
2. **Collect every thread** — both top-level review comments and inline code comments. Skip ones already resolved or clearly just approvals/"LGTM". Note who left each and the `file:line` it's anchored to.
3. **Triage each comment** into:
   - **I'll fix it** — a concrete, actionable change I can make (bug, rename, missing test, simplification). Make the edit.
   - **Needs your call** — a design question, a trade-off, or something ambiguous. Don't guess — ask me, quoting the comment.
   - **Discuss / push back** — where I think the reviewer may be wrong or it's out of scope. Flag it with my reasoning so you can decide whether to reply or defer.
4. **Make the fixes** — apply the "I'll fix it" changes. Group related ones. After editing, **verify**: run the relevant tests or build (per the repo's tooling); say so honestly if you couldn't.
5. **Report back** — a per-comment rundown: what you changed (with `file:line`), what you need me to decide, and what you'd push back on. Don't commit or reply on the PR yet.

## Rules
- Don't commit, push, or reply to comments on GitHub unless I ask — leave that to `/commit` and my say-so.
- Address the substance of each comment, not just the literal wording. If a comment reveals a pattern, fix the other instances too and note it.
- Don't silently drop a comment. Every thread ends up in one of the three buckets.
- If a requested change looks wrong or risky, don't just make it — raise it under "Discuss / push back".

## Output
A per-comment list grouped by the three buckets, each with its `file:line` and outcome, then a one-line note of what I verified. No preamble.
