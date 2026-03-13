{ hostname, username, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  networking.hostName = hostname;
  networking.computerName = hostname;
  networking.localHostName = hostname;
  system.primaryUser = username;

  system.stateVersion = 6;
}
