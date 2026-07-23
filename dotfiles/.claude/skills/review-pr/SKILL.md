---
name: review-pr
description: >
  PR reviewer. Given a GitHub PR (number/URL) or a Jira key, resolve the PR (for a Jira
  key, find linked PRs across repos), check it out in an isolated worktree, ask whether to
  run it, then review the diff and give categorised feedback. Invoke with "/review-pr 123",
  "/review-pr owner/repo#123", "review PROJ-123", or "review this PR".
argument-hint: "[PR number/URL | JIRA-KEY]"
allowed-tools:
  - "Bash(~/.claude/scripts/resolve-pr.sh:*)"
  - "Bash(gh pr view:*)"
  - "Bash(gh pr list:*)"
  - "Bash(gh pr diff:*)"
  - "Bash(gh pr checkout:*)"
  - "Bash(gh search prs:*)"
  - "Bash(gh repo view:*)"
  - "Bash(git worktree:*)"
  - "Bash(git fetch:*)"
  - "Bash(git diff:*)"
  - "Bash(git log:*)"
  - "Bash(git checkout:*)"
  - "Bash(git switch:*)"
  - "Bash(git branch:*)"
  - "Bash(git status:*)"
  - "Bash(cat:*)"
  - "Bash(cd:*)"
---

Review a pull request end to end: resolve it, check it out in isolation, optionally run it, and give me categorised feedback. Don't change the PR's state.

## Steps

### 1. Resolve the target
Run `~/.claude/scripts/resolve-pr.sh resolve <arg>` — it prints one JSON candidate per line (`{repo,number,title,headRefName,baseRefName,url,state}`) from a bare number, `owner/repo#123`, a PR URL, or a Jira key.
- **For a Jira key**, try the Atlassian MCP development/linked-PR data *first* (richer, cross-repo); the script's `gh search prs` is the fallback. A ticket often spans **more than one repo** — surface *every* PR, grouped by repo.
- **One candidate** → use it. **Several** → list them and let me pick with the **structured question tool (`AskUserQuestion`)**, one option per PR (repo + title + state). Note any repos with a matching branch but no open PR yet.
- **Zero candidates** → say so and stop; don't guess.

### 2. Check it out in an isolated workspace
Never disturb my current working tree. Run `~/.claude/scripts/resolve-pr.sh worktree <arg>` for the chosen PR — it does the `gh pr checkout` + `git worktree add ../<repo>-pr-<n>` and re-emits the JSON with a `worktree` path. Tell me that path; everything below happens in that worktree. (The `worktree` command refuses an ambiguous ref, so pick in step 1 first.)

### 3. Ask whether to run it
Use the **structured question tool (`AskUserQuestion`)**: *"Run the code to test it?"* — options **Yes** / **No**.
- **Yes** → build and run it via the project's own path: a `/run` skill if one exists, otherwise the build/test command you can infer (`package.json` scripts, `Makefile`, etc.). Report what happened — build errors, whether it started, any smoke-test output. Don't silently swallow failures.
- **No** → skip running; go straight to the review.

### 4. Review the code
Delegate the diff review to the **`code-reviewer` agent** (read-only) against the PR's diff vs its base (`git diff <base>...HEAD`). Then present its findings to me **categorised**, each item with `file:line`, the consequence, and a suggested fix:
- **🔴 Blockers** — correctness bugs, broken logic, data loss, anything that must change before merge.
- **🟠 Edge cases & regressions** — unhandled inputs, boundary conditions, likely breakage of existing callers.
- **🔵 Security** — injection, secret handling, authz gaps, unsafe deserialisation.
- **🟡 Performance** — needless work, N+1s, blocking calls on hot paths.
- **⚪ Maintainability & tests** — duplication, unclear naming, missing/weak test coverage.
Lead with a one-line verdict (approve / approve-with-nits / needs-work). If a category is empty, omit it. If the diff is clean, say so plainly.

### 5. Wrap up
Give me the verdict and the categorised feedback. Then ask whether to remove the worktree (`git worktree remove …`) or leave it for me to poke at — and tell me its path either way.

## Rules
- **Read-only on the PR**: never push, comment, approve, request changes, merge, or otherwise change the PR's state on GitHub — this produces feedback for me, not for the PR thread, unless I explicitly ask.
- The worktree is disposable; never touch my main working tree or current branch.
- Don't start fixing the code — review and report. Wait for my direction.

## Output
The resolved PR (repo + number + title), the worktree path, whether it was run (and the result), and the categorised feedback under a one-line verdict. No preamble.
