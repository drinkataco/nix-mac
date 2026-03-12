{ darwin, hostname, system }:
darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit hostname system;
  };
  modules = [
    ../hosts/${hostname}
  ];
}
