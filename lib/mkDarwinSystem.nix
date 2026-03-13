{ darwin, hostname, system, username }:
darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit hostname system username;
  };
  modules = [
    ../hosts/${hostname}
  ];
}
