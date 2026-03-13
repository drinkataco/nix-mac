#!/usr/bin/env bash

set -euo pipefail

readonly COLOR_BLUE='\033[1;34m'
readonly COLOR_RED='\033[1;31m'
readonly COLOR_RESET='\033[0m'

readonly DEFAULT_REPO_URL='https://github.com/drinkataco/nix-mac.git'
readonly DEFAULT_REPO_DIR="${HOME}/projects/nix-mac"
readonly DEFAULT_HOSTNAME='watts'

REPO_URL="${DEFAULT_REPO_URL}"
REPO_DIR="${DEFAULT_REPO_DIR}"
HOSTNAME_VALUE="${DEFAULT_HOSTNAME}"
INSTALL_NIX='1'
readonly NIX_INSTALL_CONFIG=$'experimental-features = nix-command flakes'

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
# Prints a formatted error message and exits.
# Arguments:
#   $1: Error message to display.
#######################################
err() {
  printf '\n%bError:%b %s\n' "${COLOR_RED}" "${COLOR_RESET}" "$1" >&2
  exit 1
}

#######################################
# Prints command usage and options.
#######################################
usage() {
  cat <<EOF
Usage:
  bash bootstrap.sh [options]

Description:
  Installs Xcode Command Line Tools and upstream Nix if needed, clones or
  updates this repo, and applies the nix-darwin configuration for the selected
  host.

Options:
  --hostname HOSTNAME   Flake host to build. Default: ${DEFAULT_HOSTNAME}
  --repo-dir PATH       Checkout path. Default: ${DEFAULT_REPO_DIR}
  --repo-url URL        Git URL for this repository. Default: ${DEFAULT_REPO_URL}
  --no-install-nix      Skip Nix installation.
  -h, --help            Show this help text.

Examples:
  bash bootstrap.sh
  bash bootstrap.sh --hostname watts
  bash bootstrap.sh --repo-url https://github.com/drinkataco/nix-mac.git
EOF
}

#######################################
# Parses command-line flags into script variables.
# Globals:
#   HOSTNAME_VALUE
#   INSTALL_NIX
#   REPO_DIR
#   REPO_URL
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
parse_args() {
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
      --no-install-nix)
        INSTALL_NIX='0'
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
# Verifies a required command is available.
# Arguments:
#   $1: Command name to check.
#######################################
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || err "Missing required command: $1"
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
# Installs upstream Nix unless it is already present or explicitly disabled.
# Globals:
#   INSTALL_NIX
#######################################
install_nix() {
  if command -v nix >/dev/null 2>&1; then
    log "Nix already installed"
    return
  fi

  if [[ "$INSTALL_NIX" != "1" ]]; then
    err "Nix is not installed and INSTALL_NIX is disabled"
  fi

  log "Installing upstream Nix"
  sh <(curl -L https://nixos.org/nix/install)
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
# Verifies that Git is available for cloning the repo.
#######################################
ensure_git() {
  require_cmd git
}

#######################################
# Clones the repo or fast-forwards an existing checkout.
# Globals:
#   REPO_DIR
#   REPO_URL
#######################################
sync_repo() {
  if [[ -d "$REPO_DIR/.git" ]]; then
    log "Updating existing repo at $REPO_DIR"
    git -C "$REPO_DIR" fetch --all --prune
    git -C "$REPO_DIR" pull --ff-only
    return
  fi

  log "Cloning repo into $REPO_DIR"
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone "$REPO_URL" "$REPO_DIR"
}

#######################################
# Applies the nix-darwin configuration for the selected host.
# Globals:
#   HOSTNAME_VALUE
#   REPO_DIR
#######################################
first_switch() {
  log "Applying nix-darwin configuration for host $HOSTNAME_VALUE"
  cd "$REPO_DIR"
  nix flake update
  sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ".#$HOSTNAME_VALUE"
}

#######################################
# Runs the bootstrap workflow from argument parsing through first switch.
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
main() {
  parse_args "$@"
  install_xcode_clt
  ensure_git
  install_nix
  load_nix
  sync_repo
  first_switch
}

main "$@"
