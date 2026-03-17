#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: service.sh <command>

Commands:
  status          Show /nix mount, daemon socket, and launchd status
  daemon-restart  Restart the nix-daemon launchd service
  shell-env       Print the command to load Nix into the current shell
EOF
}

status() {
  echo '== /nix mount =='
  mount | grep ' /nix ' || echo 'Not mounted'
  echo

  echo '== daemon socket =='
  ls -l /nix/var/nix/daemon-socket/socket 2>/dev/null || echo 'Socket missing'
  echo

  echo '== launch daemon plist =='
  ls -l /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || echo 'LaunchDaemon plist missing'
  echo

  echo '== launchctl =='
  sudo launchctl list | grep nix || echo 'No nix launchd services found'
}

daemon_restart() {
  sudo launchctl kickstart -k system/org.nixos.nix-daemon
}

shell_env() {
  echo '. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
}

main() {
  local command="${1:-}"

  case "${command}" in
    status)
      status
      ;;
    daemon-restart)
      daemon_restart
      ;;
    shell-env)
      shell_env
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"
