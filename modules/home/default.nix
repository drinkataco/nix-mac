{ username, ... }:
{
  imports = [
    ./dotfiles.nix
    ./ssh.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
