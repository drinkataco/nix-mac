# Global work guide

Applies to all my projects. Repo-specific `CLAUDE.md` files override this where they conflict. These guidelines bias toward caution over speed — for trivial tasks, use judgement.

## Think before coding
- Don't assume, and don't hide confusion. State your assumptions explicitly; if uncertain, ask rather than guess.
- If multiple interpretations exist, surface them — don't pick one silently.
- If a simpler approach exists, say so. Push back when warranted.
- Bias to action once the request is clear. Don't ask for confirmation on reversible, in-repo work; do confirm before anything outward-facing or hard to undo.

## Working style
- Be concise. Lead with the answer or result, then the detail. Skip preamble and restating my request.
- When you're uncertain, say so and give your best recommendation rather than a survey of options.
- Write in British English (behaviour, colour, -ise/-isation) in prose, comments, and docs. Leave code identifiers, APIs, and third-party names as they are.

## Scope & simplicity
- Write the minimum code that solves the problem — nothing speculative. No features beyond what was asked, no abstractions for single-use code, no configurability I didn't request, no error handling for impossible cases.
- If it's 200 lines and could be 50, rewrite it. Ask yourself: would a senior engineer call this overcomplicated?
- Make surgical changes — touch only what the request needs. Don't "improve" adjacent code, comments, or formatting; don't refactor what isn't broken. Every changed line should trace to my request.
- Clean up only your own mess: remove imports/variables/functions *your* change orphaned; leave pre-existing dead code (mention it, don't delete it) unless I ask.

## Verification
- Turn tasks into verifiable goals and loop until they're met: "fix the bug" → write a test that reproduces it, then make it pass; "add validation" → tests for the invalid inputs first; "refactor X" → tests green before and after.
- For multi-step work, state a brief plan with a check per step before diving in.
- After a code change, verify it: run the relevant tests or build. If you didn't verify, say so explicitly — don't imply it works.
- Report failures honestly with the actual output. "Done and verified" only when it's genuinely both.

## Code
- Match the conventions of the surrounding code — naming, comment density, structure. Don't introduce a new style.
- Prefer editing existing files over creating new ones. Don't add comments that just narrate the code.
- Primary languages: TypeScript and Lua. Follow existing tooling (formatter/linter) rather than imposing preferences.

## Git
- Never commit or push unless I ask. When I do ask, don't add "Co-Authored-By" or advertising trailers.
- If I'm on the default branch (`master`/`main`) and about to make non-trivial changes, branch first.
- Name branches `<type>/<slug>` with a `fix/`, `feature/`, or `chore/` prefix, and include the Jira ticket key when there is one (e.g. `feature/PROJ-123-oauth-login`).
- Keep commit messages factual and imperative; describe *why*, not just *what*.

## Notes
- My notes live in the Notion **Notes** wiki database: <https://app.notion.com/p/877a4012781840eda6b28cf0e122e5da>. New notes go there, not scattered elsewhere.
- Prefer the `note-writer` agent for creating notes — it seeds the page and opens it. Reach for it when I say "take a note", "note this down", or hand over a Jira key with a note-taking intent.
- It's a **wiki** database, so pages parent to the wiki page (parent type `page` with the wiki URL), not to the data source.
- Tag each note from the existing `Tags` options where one fits: Endeavor, Roku, Econify, AWS, Streaming, Personal, Meetings, Business, Monitoring, Linux, Project, Languages. Don't invent new tags without asking.

## Delegating to agents & skills
- When an agent's trigger phrase matches, use it — don't inline work an agent handles better. All my custom agents are loaded per session; check the list.
- `code-reviewer` — before I commit/PR a substantive change.
- `test-runner` — to run a suite without cluttering the main thread. Say "run"/"check" for report-only, or "fix"/"get to green" to let it edit and loop.
- `debugger` — for non-obvious bugs needing methodical root-cause work.
- Built-in `Explore`/`Plan` for broad search and planning rather than doing it all inline.
- Skills own the git workflow (`/start`, `/commit`, `/pr`, `/address-comments`, `/summarise`) — prefer them over raw git commands.
