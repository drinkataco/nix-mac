#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH}")" && pwd)"
readonly SCRIPT_DIR
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/_shared.sh"

#######################################
# Prints command usage and options.
#######################################
usage() {
  cat <<EOF
Usage:
  bash provision-init.sh [options]

Description:
  Clones or updates this repo and applies the nix-darwin configuration.

Options:
  --hostname HOSTNAME   Flake host to build. Default: ${DEFAULT_HOSTNAME}
  --repo-dir PATH       Checkout path. Default: ${DEFAULT_REPO_DIR}
  --repo-url URL        Git URL for this repository. Default: ${DEFAULT_REPO_URL}
  -h, --help            Show this help text.
EOF
}

#######################################
# Runs the provisioning workflow.
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
main() {
  parse_shared_args "$@"
  set -- "${SHARED_ARGS_REMAINDER[@]}"

  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  [[ $# -eq 0 ]] || err "Unknown argument: $1"

  load_nix
  sync_repo
  provision_system
}

main "$@"
