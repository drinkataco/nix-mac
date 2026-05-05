# git

* [General usage](#general-usage)
* [Branch switching and file restore](#branch-switching-and-file-restore)
* [Status, diff, and log](#status-diff-and-log)
* [Rebase and sync](#rebase-and-sync)
* [Push, stash, and worktrees](#push-stash-and-worktrees)
* [Recovery and cleanup](#recovery-and-cleanup)
* [Bisect](#bisect)
* [Config in this setup](#config-in-this-setup)

## General usage

- This shell loads the Oh My Zsh `git` plugin through Zim, so aliases like `gst`, `gsw`, and `grbm` are available by default in this setup.
- Git defaults in this setup:
  - `pull.rebase=true`
  - `branch.autosetuprebase=always`
  - `push.autosetupremote=true`
  - `push.followtags=true`
  - `rerere.enabled=true`
  - `core.pager=delta`
  - `diff.tool=nvimdiff`
  - `merge.tool=nvimdiff`
  - `merge.conflictstyle=zdiff3`
- Prefer the newer commands when the intent is more specific:
  - `git switch` for changing branches
  - `git restore` for restoring files
- `git checkout` still works, but it is overloaded, so it is less clear in shell history and easier to misuse.

## Branch switching and file restore

- `gsw`
  - `git switch`
  - switch branches using the newer dedicated command
- `gswc`
  - `git switch --create`
  - create and switch to a new branch in one step
- `gswm`
  - `git switch $(git_main_branch)`
  - jump back to the repo's main branch without caring whether it is `main` or `master`
- `gco`
  - `git checkout`
  - older all-purpose command for switching branches or restoring files
- `gcb`
  - `git checkout -b`
  - older way to create and switch to a branch
- `gcm`
  - `git checkout $(git_main_branch)`
  - older way to jump to the repo's main branch
- `grs`
  - `git restore`
  - restore file content in the working tree
- `grst`
  - `git restore --staged`
  - unstage a file without touching its working tree changes

## Status, diff, and log

- `gst`
  - `git status`
  - full working tree status
- `gss`
  - `git status --short`
  - compact status view
- `gsb`
  - `git status --short --branch`
  - compact status plus current branch and tracking state
- `gd`
  - `git diff`
  - inspect unstaged changes
- `gds`
  - `git diff --staged`
  - inspect what will go into the next commit
- `gdcw`
  - `git diff --cached --word-diff`
  - useful for prose, config, and small line edits where word-level diffs read better
- `glo`
  - `git log --oneline --decorate`
  - quick recent history with branch and tag names
- `glog`
  - `git log --oneline --decorate --graph`
  - same as `glo` with branch structure drawn out
- `glola`
  - `git log --graph --pretty=... --all`
  - best quick overview when you want to understand local and remote branch layout
- `gdiff`
  - custom alias
  - opens changed files in Neovim tabs and runs Fugitive diffs
  - useful when reviewing a set of changes inside the editor

## Rebase and sync

- `gl`
  - `git pull`
  - in this setup it rebases by default because `pull.rebase=true`
- `gpr`
  - `git pull --rebase`
  - explicit form of the same sync behavior
- `gfa`
  - `git fetch --all --tags --prune`
  - refresh all remotes, tags, and prune stale remote-tracking refs
- `grbm`
  - `git rebase $(git_main_branch)`
  - rebase the current branch on top of the main branch
- `grbi`
  - `git rebase --interactive`
  - clean up commits before pushing by rewording, squashing, reordering, or dropping them
- `grbc`
  - `git rebase --continue`
  - continue after resolving a rebase conflict
- `grba`
  - `git rebase --abort`
  - cancel a rebase and return to the pre-rebase state

## Push, stash, and worktrees

- `gp`
  - `git push`
  - normal publish command
- `gpf`
  - `git push --force-with-lease`
  - safer force-push that protects you from overwriting remote changes you have not seen
- `gsta`
  - `git stash push`
  - stash current changes
- `gstp`
  - `git stash pop`
  - restore the latest stash and remove it from the stash list
- `gstl`
  - `git stash list`
  - view current stashes
- `gwt`
  - `git worktree`
  - manage multiple checked-out branches in separate directories
- `gwta`
  - `git worktree add`
  - create another working tree for a branch
- `gwtls`
  - `git worktree list`
  - list active worktrees

## Recovery and cleanup

- `grf`
  - `git reflog`
  - recovery tool for finding previous branch tips, commits, and resets
- `oldest-ancestor`
  - custom alias
  - finds the earliest common first-parent ancestor between two branches
  - useful for branch archaeology when normal merge-base output is not enough
- `grhh`
  - `git reset --hard`
  - destructive reset of index and working tree to `HEAD`
- `gwipe`
  - `git reset --hard && git clean --force -df`
  - destructive cleanup of tracked changes plus untracked files and directories
- `gpristine`
  - `git reset --hard && git clean --force -dfx`
  - destructive cleanup including ignored files

Use the destructive aliases deliberately. `grf` is often the first place to look if you need to recover from one of them.

## Bisect

- Built-in bisect aliases from the git plugin:
  - `gbs`
    - `git bisect`
  - `gbss`
    - `git bisect start`
  - `gbsg`
    - `git bisect good`
  - `gbsb`
    - `git bisect bad`
  - `gbsr`
    - `git bisect reset`
  - `gbsn`
    - `git bisect new`
  - `gbso`
    - `git bisect old`
- Typical bisect flow:
  - start the search:
    - `gbss`
  - mark the known bad revision:
    - `gbsb`
  - mark the known good revision:
    - `gbsg <commit>`
  - Git will check out a midpoint commit
  - test that commit
  - mark it:
    - `gbsb` if the bug is present
    - `gbsg` if the bug is absent
  - repeat until Git identifies the first bad commit
  - return to your original branch:
    - `gbsr`
- Common practical pattern:
  - `gbss`
  - `gbsb`
  - `gbsg main~50`
  - run the test or reproduce the bug
  - keep using `gbsb` or `gbsg`
  - finish with `gbsr`
- If the repo history predates `good`/`bad` language in examples:
  - `gbsn` means `git bisect new`
  - `gbso` means `git bisect old`

## Config in this setup

- shell aliases:
  - [`dotfiles/.zsh/alias.zsh`](../dotfiles/.zsh/alias.zsh)
- plugin loading:
  - [`dotfiles/.zimrc`](../dotfiles/.zimrc)
- repo-local notes for Git diffing in Neovim:
  - [`docs/nvim.md`](./nvim.md)
