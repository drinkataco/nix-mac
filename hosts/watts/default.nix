{ hostname, username, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  networking.hostName = hostname;
  networking.computerName = hostname;
  networking.localHostName = hostname;
  system.primaryUser = username;

  homebrew.casks = [
    "steam"
  ];

  system.stateVersion = 6;
}
