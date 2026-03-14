{ lib, pkgs, ... }:
{
  home.activation.installTpm =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "$HOME/.tmux/plugins/tpm/.git" ]; then
        mkdir -p "$HOME/.tmux/plugins"
        "${pkgs.git}/bin/git" clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
      fi
    '';
}
