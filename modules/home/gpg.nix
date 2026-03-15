{ lib, ... }:
{
  home.activation.fixGpgPermissions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "$HOME/.gnupg" ]; then
      chmod 700 "$HOME/.gnupg" 2>/dev/null || true
      find "$HOME/.gnupg" -mindepth 1 -type d -exec chmod 700 {} \; 2>/dev/null || true
      find "$HOME/.gnupg" -type f -exec chmod 600 {} \; 2>/dev/null || true
    fi
  '';
}
