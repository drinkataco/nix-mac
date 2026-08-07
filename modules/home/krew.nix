{
  config,
  lib,
  pkgs,
  ...
}:
let
  # krew has no native manifest, so this list is the declarative source of
  # truth; the activation below reconciles it into ~/.krew idempotently.
  krewPlugins = [
    "ctx"
    "ns"
  ];
in
{
  home.sessionPath = [ "${config.home.homeDirectory}/.krew/bin" ];

  home.activation.installKrewPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export KREW_ROOT="$HOME/.krew"
    krew="${pkgs.krew}/bin/krew"

    # nixpkgs ships the binary as `krew`, so expose a `kubectl-krew` shim on
    # PATH to make `kubectl krew` work, not just `krew` directly.
    mkdir -p "$KREW_ROOT/bin"
    ln -sf "$krew" "$KREW_ROOT/bin/kubectl-krew"

    [ -d "$KREW_ROOT/index" ] || "$krew" update

    for plugin in ${lib.escapeShellArgs krewPlugins}; do
      "$krew" list 2>/dev/null | grep -qx "$plugin" || "$krew" install "$plugin"
    done
  '';
}
