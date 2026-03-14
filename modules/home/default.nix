{ pkgs, ... }:
{
  imports = [
    ./dotfiles.nix
    ./ssh.nix
  ];

  home.stateVersion = "25.05";
  home.sessionVariables.ZIM_NIX_PATH = "${pkgs.zimfw}";

  programs.home-manager.enable = true;
}
