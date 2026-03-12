{ hostname, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  networking.hostName = hostname;
  networking.computerName = "MacBook Pro";
  networking.localHostName = hostname;

  system.stateVersion = 6;
}
