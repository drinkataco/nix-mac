{ lib, ... }:
{
  home.activation.fixSshPermissions =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d "$HOME/.ssh" ]; then
        chmod 700 "$HOME/.ssh" || true
        find "$HOME/.ssh" \
          \( -path "$HOME/.ssh/keys" -o -path "$HOME/.ssh/keys/*" \) -prune -o \
          -type f -name "*.pub" -exec chmod 644 {} \; 2>/dev/null || true
        find "$HOME/.ssh" \
          \( -path "$HOME/.ssh/keys" -o -path "$HOME/.ssh/keys/*" \) -prune -o \
          -type f ! -name "*.pub" -exec chmod 600 {} \; 2>/dev/null || true
      fi
    '';
}
