{ inputs, darwin, hostname, system, username }:
darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit inputs hostname system username;
  };
  modules = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit inputs hostname system username;
      };
      home-manager.users.${username} = import ../modules/home;
    }
    ../hosts/${hostname}
  ];
}
