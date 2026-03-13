#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/_shared.sh"

#######################################
# Prints command usage and options.
#######################################
usage() {
  cat <<EOF
Usage:
  bash bootstrap.sh [options]

Description:
  Convenience wrapper that runs:
    1. prepare.sh
    2. install.sh
    3. provision-init.sh

Options:
  --hostname HOSTNAME   Flake host to build. Default: ${DEFAULT_HOSTNAME}
  --repo-dir PATH       Checkout path. Default: ${DEFAULT_REPO_DIR}
  --repo-url URL        Git URL for this repository. Default: ${DEFAULT_REPO_URL}
  -h, --help            Show this help text.
EOF
}

#######################################
# Runs the three-phase bootstrap flow.
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

  bash "${SCRIPT_DIR}/prepare.sh"
  bash "${SCRIPT_DIR}/install.sh"
  bash "${SCRIPT_DIR}/provision-init.sh" \
    --hostname "${HOSTNAME_VALUE}" \
    --repo-dir "${REPO_DIR}" \
    --repo-url "${REPO_URL}"
}

main "$@"
