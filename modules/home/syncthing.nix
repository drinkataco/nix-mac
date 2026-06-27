{ pkgs, ... }:
{
  home.packages = [
    pkgs.syncthing
  ];

  services.syncthing = {
    enable = true;

    # Device IDs and shared folders are operational state. Keep them editable in
    # the web UI until there is a concrete reason to make that topology
    # declarative.
    overrideDevices = false;
    overrideFolders = false;

    # Keep the admin UI local-only. Use the browser on this machine, SSH
    # forwarding, or a VPN rather than exposing Syncthing's GUI on the LAN.
    guiAddress = "127.0.0.1:8384";
  };
}
