{
  features,
  lib,
  pkgs,
  ...
}:
let
  activationReadlink = pkgs.runCommand "activation-readlink" { } ''
    mkdir -p "$out/bin"
    ln -s ${pkgs.coreutils}/libexec/gnubin/readlink "$out/bin/readlink"
  '';
in
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
  home.extraActivationPath = [ activationReadlink ];
}
