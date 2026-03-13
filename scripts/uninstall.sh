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
  bash uninstall.sh [options]

Description:
  Removes an existing macOS Nix installation and related installer leftovers.

Options:
  -h, --help            Show this help text.
EOF
}

#######################################
# Parses command-line flags.
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
parse_args() {
  [[ $# -eq 0 ]] && return
  [[ $# -eq 1 && ( "${1}" == "-h" || "${1}" == "--help" ) ]] && {
    usage
    exit 0
  }

  err "Unknown argument: $1"
}

#######################################
# Prompts for explicit confirmation before destructive steps.
#######################################
confirm_reset() {
  warn "This will remove the existing Nix installation from this Mac."
  warn "That includes /etc/nix, /nix, and installer backup files in /etc."
  printf 'Type "uninstall-nix" to continue: '

  local response
  read -r response </dev/tty
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
    /etc/bashrc.backup-before-nix \
    /etc/zshrc.backup-before-nix \
    /etc/bash.bashrc.backup-before-nix \
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
# Runs the uninstall workflow.
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
main() {
  parse_args "$@"
  confirm_reset
  unload_nix_daemon
  remove_nix_files
  remove_nix_volume
}

main "$@"
