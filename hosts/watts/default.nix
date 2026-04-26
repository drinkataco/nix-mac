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

  # Remove old Homebrew downloads, caches, and unneeded app bundles on rebuild
  homebrew.cleanUp = "zap";

  # Upgrade already-installed Homebrew formulae and casks during activation
  homebrew.Upgrade = true;

  # Host-specific Nix packages for watts
  environment.systemPackages = [
    # Scarlett MixControl
    (pkgs.callPackage ../../modules/darwin/apps/packages/scarlett-mixcontrol.nix { })
  ];

  system.stateVersion = 6;
}
