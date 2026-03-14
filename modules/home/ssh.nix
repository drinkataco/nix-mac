{
  home.activation.fixSshPermissions =
    config.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d "$HOME/.ssh" ]; then
        chmod 700 "$HOME/.ssh" || true
        find "$HOME/.ssh" -type f -name "*.pub" -exec chmod 644 {} \; || true
        find "$HOME/.ssh" -type f ! -name "*.pub" -exec chmod 600 {} \; || true
      fi
    '';
}
