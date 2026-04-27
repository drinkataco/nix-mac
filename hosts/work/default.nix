{ hostname, pkgs, username, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  networking.hostName = hostname;
  networking.computerName = hostname;
  networking.localHostName = hostname;
  system.primaryUser = username;

  # Host-specific Homebrew casks for work
  homebrew.casks = [
    "malwarebytes"
  ];

  # Remove old Homebrew downloads, caches, and unneeded app bundles on rebuild
  homebrew.cleanUp = "zap";

  # Upgrade already-installed Homebrew formulae and casks during activation
  homebrew.upgrade = true;

  # Allow Homebrew taps to update outside the pinned Nix-managed revisions
  homebrew.mutableTaps = false;

  # Host-specific Nix packages for work
  environment.systemPackages = [
    pkgs.openconnect
  ];

  system.stateVersion = 6;
}
