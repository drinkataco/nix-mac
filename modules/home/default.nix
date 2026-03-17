{ ... }:
{
  imports = [
    ./dotfiles.nix
    ./games.nix
    ./gpg.nix
    ./node.nix
    ./ssh.nix
    ./tmux.nix
  ];

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
