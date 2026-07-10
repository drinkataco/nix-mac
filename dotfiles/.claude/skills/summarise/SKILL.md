---
name: summarise
description: >
  Summarise what has changed — the working tree by default, or a branch/commit range if
  I name one. Read-only: explains the changes, never edits or commits. Invoke when I say
  "summarise the changes", "what changed", "what's in this branch", or "/summarise".
model: sonnet
argument-hint: "[branch | range | \"since <time>\"]"
disallowed-tools:
  - "Edit"
  - "Write"
---

Explain what has changed, in plain prose. This is read-only — do not edit, stage, or commit anything.

## Scope — pick from what I asked
- **Default (no argument)**: the working tree — `git status`, `git diff` (unstaged) and `git diff --staged` (staged).
- **A branch or range** (e.g. `/summarise master..HEAD` or a branch name): `git log` + `git diff` for that range against its base.
- **"Since <time>"** or a commit count: the matching `git log -p` window.
Read enough of the actual diff to describe it accurately — don't summarise from filenames alone.

## What to produce
1. **One-line headline** — the gist of the change in a sentence.
2. **Grouped bullets** — the notable changes, grouped by area/file when there are several. Say *what changed and why it matters*, not a line-by-line readback of the diff.
3. **Call out** anything that stands out: unrelated changes mixed in, likely-unintended edits, TODOs/debug leftovers, or things that look like they belong in a separate commit.

## Rules
- Prose and bullets, not a raw diff dump. Assume I've seen the diff — tell me what it *means*.
- Match the depth to the size: a one-liner for a tiny change, grouped bullets for a big one.
- Don't invent significance. If it's a trivial change, say so in a sentence and stop.
- Read-only. Never modify files, never run anything that changes state.

## Output
Headline, then grouped bullets. No preamble.
