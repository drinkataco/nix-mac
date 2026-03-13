#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/_shared.sh"

#######################################
# Prints command usage and options.
#######################################
usage() {
  cat <<EOF
Usage:
  bash prepare.sh

Description:
  Installs Xcode Command Line Tools if they are not already present.
EOF
}

#######################################
# Installs Xcode Command Line Tools if they are not already present.
#######################################
install_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools already installed"
    return
  fi

  log "Installing Xcode Command Line Tools"
  xcode-select --install || true

  printf 'Finish the Apple installer window, then press Enter to continue... '
  read -r _

  until xcode-select -p >/dev/null 2>&1; do
    printf 'Waiting for Xcode Command Line Tools installation to complete...\n'
    sleep 5
  done
}

#######################################
# Runs the machine preparation workflow.
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
main() {
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  install_xcode_clt
}

main "$@"
