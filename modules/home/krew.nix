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
    bootstrap="${pkgs.krew}/bin/krew"

    # krew v0.4+ requires krew to be self-installed (receipt at ~/.krew/receipts/krew.yaml).
    # A home without the receipt is either fresh or from the old nixpkgs-shim approach;
    # remove it so the bootstrap below starts clean.
    if [ -d "$HOME/.krew" ] && ! [ -f "$HOME/.krew/receipts/krew.yaml" ]; then
      rm -rf "$HOME/.krew"
    fi

    if ! [ -f "$HOME/.krew/receipts/krew.yaml" ]; then
      "$bootstrap" install krew
    fi

    krew="$HOME/.krew/bin/kubectl-krew"
    [ -d "$HOME/.krew/index/default" ] || "$krew" update

    for plugin in ${lib.escapeShellArgs krewPlugins}; do
      "$krew" list 2>/dev/null | grep -qx "$plugin" || "$krew" install "$plugin"
    done
  '';
}
