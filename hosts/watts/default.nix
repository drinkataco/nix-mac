{ hostname, pkgs, username, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  networking.hostName = hostname;
  networking.computerName = hostname;
  networking.localHostName = hostname;
  system.primaryUser = username;

  # Keep a generated ~/Applications/Games directory for games
  features.gamesDir = true;

  # Host-specific Homebrew casks for watts
  homebrew.casks = [
    #"steam"
  ];

  # Host-specific Nix packages for watts
  environment.systemPackages = [
    # Scarlett MixControl
    (pkgs.callPackage ../../modules/darwin/apps/packages/scarlett-mixcontrol.nix { })
  ];

  system.stateVersion = 6;
}
