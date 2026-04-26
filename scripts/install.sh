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
  bash install.sh

Description:
  Installs upstream Nix using the official installer.

Notes:
  If a previous or partial Nix install exists, remove it first with
  force-remove.sh. This script is only for a clean install path.
EOF
}

#######################################
# Installs upstream Nix unless it is already present.
#######################################
install_nix() {
  if command -v nix >/dev/null 2>&1; then
    log "Nix already installed"
    return
  fi

  if [[ -e /etc/nix/nix.conf || -e /etc/bashrc.backup-before-nix || -e /etc/zshrc.backup-before-nix || -d /nix ]]; then
    err "Existing Nix install state detected. Use scripts/force-remove.sh before reinstalling."
  fi

  log "Installing upstream Nix"
  curl -L https://nixos.org/nix/install | sh -s -- --daemon
}

#######################################
# Runs the Nix install workflow.
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
main() {
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  install_nix
  load_nix
}

main "$@"
