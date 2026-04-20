{ features, lib, ... }:
{
  imports = [
    ./dotfiles.nix
    ./gpg.nix
    ./node.nix
    ./ssh.nix
    ./tmux.nix
  ] ++ lib.optionals features.gamesDir [
    ./games.nix
  ];

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
