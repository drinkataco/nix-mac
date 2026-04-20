{ featGamesDir, lib, ... }:
{
  imports = [
    ./dotfiles.nix
    ./gpg.nix
    ./node.nix
    ./ssh.nix
    ./tmux.nix
  ] ++ lib.optionals featGamesDir [
    ./games.nix
  ];

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
