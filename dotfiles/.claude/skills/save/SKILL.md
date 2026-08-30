---
name: save
description: >
  Persist and reload session context to `.saves/YYYY-MM-DD-{sessionname}.md`.
  Invoke with `/save <sessionname>`: reloads any prior save for that
  session, then writes a fresh snapshot of the current state. Use for
  long-running work I want to resume in a later Claude Code session.
allowed-tools:
  - "Bash(ls:*)"
  - "Bash(mkdir:*)"
  - "Bash(date:*)"
  - "Read"
  - "Write"
---

Persist and reload session state so I can resume work in a later Claude Code session.

## Steps

1. **Resolve the session name** — take the argument passed to the skill (e.g. `/save oauth-migration` → `oauth-migration`). If none was given, stop and ask.

2. **Load prior save if any** — run:
   ```
   ls -1 .saves/*-<sessionname>.md 2>/dev/null | sort
   ```
   If any files are returned, `Read` the most recent one (last after sort) and hold its contents as loaded context. Summarise it back in 2–4 lines so I know where we're picking up. If nothing is returned, say so and continue.

3. **Snapshot the current session** — compose a fresh Markdown file capturing:
   - **Goal** — one sentence: what I'm trying to accomplish.
   - **Where we are** — bullet list of what's been done so far.
   - **Files touched** — paths edited or under active work, with one line per file.
   - **Open questions / decisions pending** — anything I've flagged or that's unresolved.
   - **Next step** — the single next action I should take when I resume.

   Keep it factual and terse. It's a handoff to future-me, not a chat transcript. If a prior save was loaded in step 2, carry forward anything from it that's still relevant — don't repeat closed items.

4. **Write the file** — path is `.saves/$(date +%Y-%m-%d)-<sessionname>.md`. Create `.saves/` if missing (`mkdir -p .saves`). If a file for today already exists for this session, overwrite it (rolling snapshot, not append-only).

## Rules
- The session name is a slug — treat the argument as-is; don't reinterpret or sanitise it.
- The snapshot is a handoff, not a diary. Describe state, not commentary.
- If nothing meaningful has happened in the session yet, say so and skip the write.
- `.saves/` is project-local. Don't reach into `$HOME` or elsewhere.
- Don't touch `.gitignore` — whether to track `.saves/` is my call.

## Output
- If a prior save was loaded: a 2–4 line summary of it and the file path it came from.
- The path of the snapshot just written.
- Nothing else.
