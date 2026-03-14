{ lib, pkgs, ... }:
let
  zimfwCandidates = [
    "${pkgs.zimfw}/share/zimfw.zsh"
    "${pkgs.zimfw}/share/zimfw/zimfw.zsh"
  ];
  candidateArgs = lib.concatStringsSep " " (map lib.escapeShellArg zimfwCandidates);
in {
  home.activation.installZimfw =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.zim"

      for candidate in ${candidateArgs}; do
        if [ -r "$candidate" ]; then
          ln -sf "$candidate" "$HOME/.zim/zimfw.zsh"
          break
        fi
      done
    '';
}
