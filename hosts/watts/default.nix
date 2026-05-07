{
  hostname,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../modules/darwin
  ];

  networking = {
    hostName = hostname;
    computerName = hostname;
    localHostName = hostname;
  };
  system.primaryUser = username;

  # Keep a generated ~/Applications/Games directory for games
  features.gamesDir = true;

  # Host-specific Homebrew casks for watts
  homebrew = {
    casks = [
      "steam"
    ];

    # Remove old Homebrew downloads, caches, and unneeded app bundles on rebuild
    cleanUp = "zap";

    # Upgrade already-installed Homebrew formulae and casks during activation
    upgrade = true;

    # Allow Homebrew taps to update outside the pinned Nix-managed revisions
    mutableTaps = false;
  };

  # Host-specific Nix packages for watts
  environment.systemPackages = [
    # Scarlett MixControl
    (pkgs.callPackage ../../modules/darwin/apps/packages/scarlett-mixcontrol.nix { })
  ];

  system.stateVersion = 6;
}
