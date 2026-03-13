#!/usr/bin/env bash

set -euo pipefail

readonly COLOR_BLUE='\033[1;34m'
readonly COLOR_RED='\033[1;31m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_RESET='\033[0m'

readonly DEFAULT_REPO_URL='https://github.com/drinkataco/nix-mac.git'
readonly DEFAULT_REPO_DIR="${HOME}/projects/nix-mac"
readonly DEFAULT_HOSTNAME='watts'

REPO_URL="${DEFAULT_REPO_URL}"
REPO_DIR="${DEFAULT_REPO_DIR}"
HOSTNAME_VALUE="${DEFAULT_HOSTNAME}"
REINSTALL_NIX='1'
APPLY_CONFIG='1'
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
# Prints command usage and options.
#######################################
usage() {
  cat <<EOF
Usage:
  bash uninstall.sh [options]

Description:
  Removes an existing macOS Nix installation, reinstalls upstream Nix,
  updates this repo, and reapplies the nix-darwin
  configuration.

Options:
  --hostname HOSTNAME   Flake host to build. Default: ${DEFAULT_HOSTNAME}
  --repo-dir PATH       Checkout path. Default: ${DEFAULT_REPO_DIR}
  --repo-url URL        Git URL for this repository. Default: ${DEFAULT_REPO_URL}
  --no-reinstall-nix    Only remove the existing installation.
  --no-apply-config     Reinstall Nix, but do not run nix-darwin.
  -h, --help            Show this help text.
EOF
}

#######################################
# Parses command-line flags into script variables.
# Globals:
#   APPLY_CONFIG
#   HOSTNAME_VALUE
#   REINSTALL_NIX
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
      --no-reinstall-nix)
        REINSTALL_NIX='0'
        APPLY_CONFIG='0'
        shift
        ;;
      --no-apply-config)
        APPLY_CONFIG='0'
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
# Prompts for explicit confirmation before destructive steps.
#######################################
confirm_reset() {
  warn "This will remove the existing Nix installation from this Mac."
  warn "That includes /etc/nix and the /nix APFS volume."
  printf 'Type "uninstall-nix" to continue: '

  local response
  read -r response
  [[ "${response}" == "uninstall-nix" ]] || err "Confirmation failed"
}

#######################################
# Unloads the nix-daemon launch daemon if it exists.
#######################################
unload_nix_daemon() {
  if [[ -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist ]]; then
    log "Unloading nix-daemon launch daemon"
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist || true
  fi
}

#######################################
# Removes Nix profiles and configuration files.
#######################################
remove_nix_files() {
  log "Removing Nix files"
  sudo rm -rf \
    /etc/nix \
    /var/root/.nix-profile \
    /var/root/.nix-defexpr \
    /var/root/.nix-channels \
    "${HOME}/.nix-profile" \
    "${HOME}/.nix-defexpr" \
    "${HOME}/.nix-channels"
}

#######################################
# Deletes the /nix APFS volume if it exists.
#######################################
remove_nix_volume() {
  if [[ -d /nix ]]; then
    log "Deleting /nix APFS volume"
    sudo diskutil apfs deleteVolume /nix || warn "Could not delete /nix automatically; a reboot may be required before retrying"
  fi
}

#######################################
# Installs upstream Nix.
#######################################
install_nix() {
  [[ "${REINSTALL_NIX}" == "1" ]] || return

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
#   APPLY_CONFIG
#   HOSTNAME_VALUE
#   REPO_DIR
#######################################
apply_config() {
  [[ "${APPLY_CONFIG}" == "1" ]] || return

  log "Applying nix-darwin configuration for host ${HOSTNAME_VALUE}"
  cd "${REPO_DIR}"
  nix flake update
  sudo -H env NIX_CONFIG="${NIX_CONFIG}" \
    nix run nix-darwin/master#darwin-rebuild -- switch --flake ".#${HOSTNAME_VALUE}"
}

#######################################
# Runs the reset workflow from argument parsing through config apply.
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
main() {
  parse_args "$@"
  confirm_reset
  unload_nix_daemon
  remove_nix_files
  remove_nix_volume
  install_nix
  load_nix
  sync_repo
  apply_config
}

main "$@"
