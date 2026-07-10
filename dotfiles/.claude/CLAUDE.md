# Global work guide

Applies to all my projects. Repo-specific `CLAUDE.md` files override this where they conflict.

## Working style
- Bias to action once the request is clear. Don't ask for confirmation on reversible, in-repo work; do confirm before anything outward-facing or hard to undo.
- Be concise. Lead with the answer or result, then the detail. Skip preamble and restating my request.
- When you're uncertain, say so and give your best recommendation rather than a survey of options.
- Write in British English (behaviour, colour, -ise/-isation) in prose, comments, and docs. Leave code identifiers, APIs, and third-party names as they are.

## Git
- Never commit or push unless I ask. When I do ask, don't add "Co-Authored-By" or advertising trailers.
- If I'm on the default branch (`master`/`main`) and about to make non-trivial changes, branch first.
- Name branches `<type>/<slug>` with a `fix/`, `feature/`, or `chore/` prefix, and include the Jira ticket key when there is one (e.g. `feature/PROJ-123-oauth-login`).
- Keep commit messages factual and imperative; describe *why*, not just *what*.

## Verification
- After a code change, verify it: run the relevant tests or build. If you didn't verify, say so explicitly — don't imply it works.
- Report failures honestly with the actual output. "Done and verified" only when it's genuinely both.

## Code
- Match the conventions of the surrounding code — naming, comment density, structure. Don't introduce a new style.
- Prefer editing existing files over creating new ones. Don't add comments that just narrate the code.
- Primary languages: TypeScript and Lua. Follow existing tooling (formatter/linter) rather than imposing preferences.

## Skills
- For the git workflow, prefer my skills over raw commands: `/start <ticket>` to begin work, then `/commit`, `/pr`, and `/address-comments` for review feedback. `/summarise` gives a read-only overview of what changed.

## Delegating to agents
- `code-reviewer` — before I commit/PR a substantive change.
- `test-runner` — to run a suite without cluttering the main thread. Say "run"/"check" for report-only, or "fix"/"get to green" to let it edit and loop.
- `debugger` — for non-obvious bugs needing methodical root-cause work.
- Use the built-in `Explore`/`Plan` agents for broad search and planning rather than doing it all inline.
