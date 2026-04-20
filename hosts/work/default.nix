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

  # Host-specific Nix packages for work
  environment.systemPackages = [
    pkgs.openconnect
  ];

  system.stateVersion = 6;
}
