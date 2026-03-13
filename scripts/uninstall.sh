#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/_shared.sh"

REINSTALL_NIX='1'
APPLY_CONFIG='1'

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
# Parses command-line flags into script variables after shared flags.
# Globals:
#   APPLY_CONFIG
#   HOSTNAME_VALUE
#   REINSTALL_NIX
# Arguments:
#   $@: CLI arguments passed to the script.
#######################################
parse_args() {
  parse_shared_args "$@"
  set -- "${SHARED_ARGS_REMAINDER[@]}"

  while [[ $# -gt 0 ]]; do
    case "$1" in
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
# Prompts for explicit confirmation before destructive steps.
#######################################
confirm_reset() {
  warn "This will remove the existing Nix installation from this Mac."
  warn "That includes /etc/nix and the /nix APFS volume."
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
  curl -L https://nixos.org/nix/install | sh
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
  [[ "${APPLY_CONFIG}" == "1" ]] || exit 0
  provision_system
}

main "$@"
