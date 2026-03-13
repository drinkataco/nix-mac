{ hostname, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  networking.hostName = hostname;
  networking.computerName = hostname;
  networking.localHostName = hostname;

  system.stateVersion = 6;
}
