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

  homebrew = {
    # Host specific caskses
    casks = [
      "malwarebytes"
    ];

    # Remove old Homebrew downloads, caches, and unneeded app bundles on rebuild
    cleanUp = "zap";

    # Upgrade during activation
    autoUpgrade = true;

    # Allow Homebrew taps to update outside the pinned Nix-managed revisions
    mutableTaps = false;
  };

  # Override default projects directory name whilst format is ported over
  projects.dirName = "projects";

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
    pkgs.openconnect
  ];

  system.stateVersion = 6;
}
