{ ... }:
{
  imports = [
    ./dotfiles.nix
    ./ssh.nix
    ./tmux.nix
  ];

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
