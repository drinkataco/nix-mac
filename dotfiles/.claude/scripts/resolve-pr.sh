#!/usr/bin/env bash
set -euo pipefail

# Resolve a PR reference to a candidate list, and optionally check it out in an
# isolated worktree. Shared by the /review-pr and /address-comments skills so the
# mechanical gh/git steps live here rather than in each SKILL.md.
#
# The *judgement* stays with Claude: when this prints more than one candidate,
# the skill picks (or asks via AskUserQuestion). This script never guesses.
#
# Usage:
#   resolve-pr.sh resolve [REF]        # print candidate PRs as JSON, one per line
#   resolve-pr.sh worktree REF         # resolve a single PR and add a worktree
#
# REF forms:
#   (omitted)        the PR for the current branch
#   72               PR #72 in the current repo
#   owner/repo#72    PR #72 in that repo
#   https://…/pull/72  a PR URL
#   ABC-123          a Jira key -> gh search prs (may span multiple repos)
#
# Output (resolve): newline-delimited JSON objects, each:
#   {repo,number,title,headRefName,baseRefName,url,state}
# A single line means an unambiguous match. Zero lines means nothing resolved.

FIELDS='number,title,headRefName,baseRefName,url,state'

die() {
  printf '%s\n' "$1" >&2
  exit 1
}

#######################################
# Emits one JSON candidate line, injecting the owning repo (gh pr view omits it).
# Arguments:
#   owner/repo slug.
#   PR JSON from `gh pr view`/`gh pr list`.
#######################################
emit() {
  local repo="$1" json="$2"
  jq -c --arg repo "$repo" '{repo:$repo} + .' <<<"$json"
}

#######################################
# Resolves the PR for the current branch. No output if there is none.
#######################################
resolve_current() {
  local repo json
  repo="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
  if json="$(gh pr view --json "$FIELDS" 2>/dev/null)"; then
    emit "$repo" "$json"
  fi
}

#######################################
# Resolves an explicit PR reference (number, owner/repo#n, or URL).
# Arguments:
#   The reference.
#######################################
resolve_explicit() {
  local ref="$1" repo="" num=""

  case "$ref" in
    *#*) repo="${ref%#*}"; num="${ref##*#}" ;;      # owner/repo#72
    http*)                                           # a PR URL
      num="${ref##*/pull/}"; num="${num%%/*}"
      repo="$(gh repo view "$ref" --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)"
      ;;
    *) num="$ref" ;;                                 # bare number, current repo
  esac

  [[ -z "$repo" ]] && repo="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
  emit "$repo" "$(gh pr view "$num" --repo "$repo" --json "$FIELDS")"
}

#######################################
# Resolves a Jira key to every matching PR across repos.
# Arguments:
#   The Jira key.
#######################################
resolve_jira() {
  local key="$1"
  # `gh search prs` matches title and branch name; a ticket often spans repos.
  gh search prs "$key" --json repository,number --jq '.[] | "\(.repository.nameWithOwner) \(.number)"' \
    | while read -r repo num; do
        [[ -z "$repo" ]] && continue
        emit "$repo" "$(gh pr view "$num" --repo "$repo" --json "$FIELDS")"
      done
}

#######################################
# Routes a reference to the right resolver.
# Arguments:
#   The reference (may be empty).
#######################################
resolve() {
  local ref="${1:-}"

  if [[ -z "$ref" ]]; then
    resolve_current
  elif [[ "$ref" =~ ^[A-Z][A-Z0-9]+-[0-9]+$ ]]; then
    resolve_jira "$ref"
  else
    resolve_explicit "$ref"
  fi
}

#######################################
# Resolves a single PR and checks it out in a sibling worktree.
# Arguments:
#   The reference (required).
# Outputs:
#   The single candidate JSON with an added "worktree" path.
#######################################
worktree() {
  local ref="${1:-}"
  [[ -z "$ref" ]] && die 'worktree needs a PR reference'

  local candidates count
  candidates="$(resolve "$ref")"
  count="$(grep -c . <<<"$candidates" || true)"
  [[ "$count" -eq 0 ]] && die "nothing resolved for: $ref"
  [[ "$count" -gt 1 ]] && die "ambiguous ($count PRs); let the skill pick before making a worktree"

  local repo num branch path
  repo="$(jq -r .repo <<<"$candidates")"
  num="$(jq -r .number <<<"$candidates")"
  branch="pr-$num"
  path="../$(basename "$repo")-pr-$num"

  gh pr checkout "$num" --repo "$repo" --branch "$branch"
  git worktree add "$path" "$branch" 2>/dev/null || true

  jq -c --arg wt "$path" '. + {worktree:$wt}' <<<"$candidates"
}

command -v gh >/dev/null || die 'gh not found'
command -v jq >/dev/null || die 'jq not found'

cmd="${1:-resolve}"
shift || true
case "$cmd" in
  resolve)  resolve "${1:-}" ;;
  worktree) worktree "${1:-}" ;;
  *)        die "unknown command: $cmd (use resolve|worktree)" ;;
esac
