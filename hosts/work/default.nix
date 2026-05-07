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

  # Host-specific Homebrew casks for work
  homebrew = {
    casks = [
      "malwarebytes"
    ];

    # Remove old Homebrew downloads, caches, and unneeded app bundles on rebuild
    cleanUp = "zap";

    # Upgrade already-installed Homebrew formulae and casks during activation
    upgrade = true;

    # Allow Homebrew taps to update outside the pinned Nix-managed revisions
    mutableTaps = false;
  };

  # Host-specific Nix packages for work
  environment.systemPackages = [
    pkgs.openconnect
  ];

  system.stateVersion = 6;
}
