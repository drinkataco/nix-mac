{ lib, pkgs, ... }:
{
  home.activation.installGlobalNodeTools =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      export PNPM_HOME="$HOME/.local/share/pnpm"
      export PATH="$PNPM_HOME:${pkgs.pnpm}/bin:$PATH"

      mkdir -p "$PNPM_HOME"

      if ! "${pkgs.pnpm}/bin/pnpm" list -g --depth=0 2>/dev/null | grep -q ' lighthouse@'; then
        "${pkgs.pnpm}/bin/pnpm" add -g lighthouse
      fi
    '';
}
