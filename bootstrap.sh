#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH}")" && pwd)"
readonly SCRIPT_DIR
readonly RAW_BASE_URL="${RAW_BASE_URL:-https://raw.githubusercontent.com/drinkataco/nix-mac/main/scripts}"
readonly SHARED_CACHE_DIR="${TMPDIR:-/tmp}/nix-mac-bootstrap"
readonly SHARED_PATH="${SHARED_CACHE_DIR}/_shared.sh"

if [[ -f "${SCRIPT_DIR}/scripts/_shared.sh" ]]; then
  # shellcheck source=scripts/_shared.sh
  . "${SCRIPT_DIR}/scripts/_shared.sh"
else
  mkdir -p "${SHARED_CACHE_DIR}"
  curl -fsSL "${RAW_BASE_URL}/_shared.sh" -o "${SHARED_PATH}"
  # shellcheck disable=SC1090
  . "${SHARED_PATH}"
fi

INSTALL_NIX='1'
PROVISION_NIX='1'

#######################################
# Prints command usage and options.
#######################################
usage() {
  cat <<EOF
Usage:
  bash bootstrap.sh [options]

Description:
  Standalone bootstrap for a fresh Mac. Installs Xcode Command Line Tools if
  needed, clones or updates this repo, and optionally runs the local install
  and initial provisioning scripts.

Options:
  --hostname HOSTNAME   Flake host to build. Default: ${DEFAULT_HOSTNAME}
  --repo-dir PATH       Checkout path. Default: ${DEFAULT_REPO_DIR}
  --repo-url URL        Git URL for this repository. Default: ${DEFAULT_REPO_URL}
  --no-install          Skip scripts/install.sh.
  --no-provision        Skip scripts/provision-init.sh.
  -h, --help            Show this help text.
EOF
}

#######################################
# Parses bootstrap arguments.
# Globals:
#   HOSTNAME_VALUE
#   INSTALL_NIX
#   PROVISION_NIX
#   REPO_DIR
#   REPO_URL
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
parse_args() {
  parse_shared_args "$@"
  if [[ ${#SHARED_ARGS_REMAINDER[@]} -gt 0 ]]; then
    set -- "${SHARED_ARGS_REMAINDER[@]}"
  else
    set --
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --no-install)
        INSTALL_NIX='0'
        shift
        ;;
      --no-provision)
        PROVISION_NIX='0'
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        err "Unknown argument: $1"
        ;;
    esac
  done
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
  read -r _ </dev/tty

  until xcode-select -p >/dev/null 2>&1; do
    printf 'Waiting for Xcode Command Line Tools installation to complete...\n'
    sleep 5
  done
}

#######################################
# Runs the standalone bootstrap flow.
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
main() {
  parse_args "$@"
  install_xcode_clt
  sync_repo

  if [[ "${INSTALL_NIX}" == '1' ]]; then
    "${REPO_DIR}/scripts/install.sh"
  fi

  if [[ "${PROVISION_NIX}" == '1' ]]; then
    "${REPO_DIR}/scripts/provision-init.sh" \
      --hostname "${HOSTNAME_VALUE}" \
      --repo-dir "${REPO_DIR}" \
      --repo-url "${REPO_URL}"
  fi
}

main "$@"
