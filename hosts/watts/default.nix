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

  # Lazy NFS mounts: rebuilds do not contact the server, and access fails
  # normally when the share is unavailable.
  networkShares.nfs.mounts = [
    "fileserver:/srv"
    "fileserver:/srv/downloads"
  ];

  homebrew = {
    # Host specific casks
    casks = [
      "dolphin"
      "pcsx2"
      "retroarch"
      "steam"
    ];

    # Remove old Homebrew downloads, caches, and unneeded app bundles on rebuild
    cleanUp = "zap";

    # Upgrade already-installed Homebrew formulae and casks during activation
    autoUpgrade = false;

    # Allow Homebrew taps to update outside the pinned Nix-managed revisions
    mutableTaps = false;
  };

  projects.dirName = "projects-new";

  pnpm = {
    # Upgrade during activation
    autoUpgrade = false;
  };

  uv = {
    # Upgrade during activation
    autoUpgrade = false;
  };

  # Host-specific Nix packages
  environment.systemPackages = [
    (pkgs.callPackage ../../modules/darwin/apps/packages/duckstation.nix { })
    (pkgs.callPackage ../../modules/darwin/apps/packages/scarlett-mixcontrol.nix { })
  ];

  system.stateVersion = 6;
}
