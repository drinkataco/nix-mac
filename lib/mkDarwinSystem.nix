{ inputs, darwin, hostname, system, username }:
darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit inputs hostname system username;
  };
  modules = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    ../hosts/${hostname}
  ];
}
