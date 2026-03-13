#!/usr/bin/env bash

set -euo pipefail

readonly COLOR_BLUE='\033[1;34m'
readonly COLOR_RED='\033[1;31m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_RESET='\033[0m'

readonly DEFAULT_REPO_URL='https://github.com/drinkataco/nix-mac.git'
readonly DEFAULT_REPO_DIR="${HOME}/projects/nix-mac"
readonly DEFAULT_HOSTNAME='watts'
readonly NIX_INSTALL_CONFIG=$'experimental-features = nix-command flakes'

REPO_URL="${DEFAULT_REPO_URL}"
REPO_DIR="${DEFAULT_REPO_DIR}"
HOSTNAME_VALUE="${DEFAULT_HOSTNAME}"
SHARED_ARGS_REMAINDER=()

export NIX_CONFIG="${NIX_INSTALL_CONFIG}"

#######################################
# Prints a formatted progress message.
# Arguments:
#   $1: Message to display.
#######################################
log() {
  printf '\n%b==>%b %s\n' "${COLOR_BLUE}" "${COLOR_RESET}" "$1"
}

#######################################
# Prints a formatted warning message.
# Arguments:
#   $1: Warning message to display.
#######################################
warn() {
  printf '\n%bWarning:%b %s\n' "${COLOR_YELLOW}" "${COLOR_RESET}" "$1"
}

#######################################
# Prints a formatted error message and exits.
# Arguments:
#   $1: Error message to display.
#######################################
err() {
  printf '\n%bError:%b %s\n' "${COLOR_RED}" "${COLOR_RESET}" "$1" >&2
  exit 1
}

#######################################
# Parses shared repository and host flags.
# Globals:
#   HOSTNAME_VALUE
#   REPO_DIR
#   REPO_URL
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
parse_shared_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --hostname)
        [[ $# -ge 2 ]] || err "--hostname requires a value"
        HOSTNAME_VALUE="$2"
        shift 2
        ;;
      --repo-dir)
        [[ $# -ge 2 ]] || err "--repo-dir requires a value"
        REPO_DIR="$2"
        shift 2
        ;;
      --repo-url)
        [[ $# -ge 2 ]] || err "--repo-url requires a value"
        REPO_URL="$2"
        shift 2
        ;;
      *)
        break
        ;;
    esac
  done

  SHARED_ARGS_REMAINDER=("$@")
}

#######################################
# Verifies a required command is available.
# Arguments:
#   $1: Command name to check.
#######################################
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || err "Missing required command: $1"
}

#######################################
# Loads Nix into the current shell session after installation.
#######################################
load_nix() {
  if command -v nix >/dev/null 2>&1; then
    return
  fi

  if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi

  command -v nix >/dev/null 2>&1 || err "Nix installed, but nix is not available in this shell yet"
}

#######################################
# Clones the repo or fast-forwards an existing checkout.
# Globals:
#   REPO_DIR
#   REPO_URL
#######################################
sync_repo() {
  require_cmd git

  if [[ -d "${REPO_DIR}/.git" ]]; then
    log "Updating existing repo at ${REPO_DIR}"
    git -C "${REPO_DIR}" fetch --all --prune
    git -C "${REPO_DIR}" pull --ff-only
    return
  fi

  log "Cloning repo into ${REPO_DIR}"
  mkdir -p "$(dirname "${REPO_DIR}")"
  git clone "${REPO_URL}" "${REPO_DIR}"
}

#######################################
# Applies the nix-darwin configuration for the selected host.
# Globals:
#   HOSTNAME_VALUE
#   REPO_DIR
#######################################
provision_system() {
  log "Applying nix-darwin configuration for host ${HOSTNAME_VALUE}"
  cd "${REPO_DIR}"
  nix flake update
  sudo -H env NIX_CONFIG="${NIX_CONFIG}" \
    nix run nix-darwin/master#darwin-rebuild -- switch --flake ".#${HOSTNAME_VALUE}"
}
