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
  bash provision.sh [options]

Description:
  Clones or updates this repo and applies the nix-darwin configuration.

Environment:
  BUILD_HOST          Flake host to build. Default: ${DEFAULT_HOSTNAME}

Options:
  --hostname HOSTNAME   Flake host to build. Default: ${DEFAULT_HOSTNAME}
  --repo-dir PATH       Checkout path. Default: ${DEFAULT_REPO_DIR}
  --repo-url URL        Git URL for this repository. Default: ${DEFAULT_REPO_URL}
  -h, --help            Show this help text.
EOF
}

#######################################
# Moves conflicting /etc shell init files aside before nix-darwin activation.
#######################################
prepare_etc_shell_files() {
  local path
  local backup_path
  local backup_index

  for path in /etc/bashrc /etc/zshrc /etc/bash.bashrc; do
    [[ -e "${path}" && ! -L "${path}" ]] || continue

    backup_path="${path}.before-nix-darwin"
    backup_index=2

    while [[ -e "${backup_path}" ]]; do
      backup_path="${path}.before-nix-darwin.${backup_index}"
      backup_index=$((backup_index + 1))
    done

    log "Backing up ${path} to ${backup_path}"
    sudo mv "${path}" "${backup_path}"
  done
}

#######################################
# Runs the provisioning workflow.
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
main() {
  parse_shared_args "$@"
  if [[ ${#SHARED_ARGS_REMAINDER[@]} -gt 0 ]]; then
    set -- "${SHARED_ARGS_REMAINDER[@]}"
  else
    set --
  fi

  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  [[ $# -eq 0 ]] || err "Unknown argument: $1"

  load_nix
  sync_repo
  prepare_etc_shell_files
  provision_system
}

main "$@"
