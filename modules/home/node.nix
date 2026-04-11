{ lib, pkgs, ... }:
let
  nodeVersions = [
    "20"
    "22"
    "24"
  ];
in
{
  home.activation.installFnmNodeVersions =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      export PATH="${pkgs.fnm}/bin:$PATH"

      ${lib.concatMapStringsSep "\n" (version: ''
        fnm install ${version}
      '') nodeVersions}

      fnm default 24
    '';

  home.activation.installGlobalNodeTools =
    lib.hm.dag.entryAfter [ "installFnmNodeVersions" ] ''
      export PNPM_HOME="$HOME/.local/share/pnpm"
      export PATH="$PNPM_HOME:${pkgs.pnpm}/bin:$PATH"

      mkdir -p "$PNPM_HOME"

      if ! "${pkgs.pnpm}/bin/pnpm" list -g --depth=0 2>/dev/null | grep -q ' lighthouse@'; then
        "${pkgs.pnpm}/bin/pnpm" add -g lighthouse
      fi
    '';
}
