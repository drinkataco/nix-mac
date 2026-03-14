{ ... }:
{
  imports = [
    ./dotfiles.nix
    ./ssh.nix
    ./zim.nix
  ];

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
