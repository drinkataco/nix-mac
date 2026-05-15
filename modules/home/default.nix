{
  features,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./dotfiles.nix
    ./gpg.nix
    ./node.nix
    ./ssh.nix
    ./tmux.nix
    ./uv.nix
  ]
  ++ lib.optionals features.gamesDir [
    ./games.nix
  ];

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.activation.prependGnuCoreutils = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
    export PATH="${pkgs.coreutils}/libexec/gnubin:$PATH"
  '';
}
