#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: service.sh <command>

Commands:
  status           Show /nix mount, daemon socket, and launchd status
  daemon-enable    Enable the nix-daemon launchd service
  daemon-bootstrap Bootstrap the nix-daemon LaunchDaemon plist
  daemon-restart   Restart the nix-daemon launchd service
  repair           Enable, bootstrap, and restart the nix-daemon service
  shell-env        Print the command to load Nix into the current shell
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

daemon_enable() {
  sudo launchctl enable system/org.nixos.nix-daemon
}

daemon_bootstrap() {
  sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist
}

repair() {
  daemon_enable || true
  daemon_bootstrap || true
  daemon_restart
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
    daemon-enable)
      daemon_enable
      ;;
    daemon-bootstrap)
      daemon_bootstrap
      ;;
    daemon-restart)
      daemon_restart
      ;;
    repair)
      repair
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
