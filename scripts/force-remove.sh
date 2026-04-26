#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH}")" && pwd)"
readonly SCRIPT_DIR
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/_shared.sh"

usage() {
  cat <<EOF
Usage:
  bash force-remove.sh [options]

Description:
  Force-removes an existing macOS Nix installation, including the /nix volume,
  daemon state, and installer leftovers.

Options:
  -h, --help            Show this help text.
EOF
}

parse_args() {
  [[ $# -eq 0 ]] && return
  [[ $# -eq 1 && ( "${1}" == "-h" || "${1}" == "--help" ) ]] && {
    usage
    exit 0
  }

  err "Unknown argument: $1"
}

confirm_reset() {
  warn "This will force-remove the existing Nix installation from this Mac."
  warn "That includes /etc/nix, Nix profiles, launchd state, and the /nix APFS volume."
  printf 'Type "force-remove-nix" to continue: '

  local response
  read -r response </dev/tty
  [[ "${response}" == "force-remove-nix" ]] || err "Confirmation failed"
}

unload_nix_daemon() {
  log "Stopping nix-daemon services"
  sudo launchctl bootout system /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true
  sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true
  sudo launchctl remove org.nixos.nix-daemon 2>/dev/null || true
  sudo pkill -f nix-daemon 2>/dev/null || true
}

remove_launchd_files() {
  log "Removing nix-daemon launchd files"
  sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist
  sudo rm -f /Library/LaunchDaemons/org.nixos.darwin-store.plist
}

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

unmount_nix_volume() {
  if mount | grep -q ' /nix '; then
    log "Unmounting /nix"
    sudo diskutil unmount force /nix || sudo umount -f /nix || warn "Could not unmount /nix automatically"
  fi
}

remove_nix_volume() {
  if [[ -d /nix ]] || mount | grep -q ' /nix '; then
    log "Deleting /nix APFS volume"
    sudo diskutil apfs deleteVolume /nix || warn "Could not delete /nix automatically; a reboot may be required before retrying"
  fi
}

prompt_restart() {
  warn "A restart is recommended to fully clear the removed Nix services and mount state."
  printf 'Restart this Mac now? [y/N] '

  local response
  read -r response </dev/tty

  case "${response}" in
    y|Y|yes|YES)
      log "Restarting Mac"
      sudo shutdown -r now
      ;;
    *)
      warn "Restart skipped. Please restart the Mac manually soon."
      ;;
  esac
}

main() {
  parse_args "$@"
  confirm_reset
  unload_nix_daemon
  remove_launchd_files
  remove_nix_files
  unmount_nix_volume
  remove_nix_volume
  prompt_restart
}

main "$@"
