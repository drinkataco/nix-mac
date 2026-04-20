{ inputs, darwin, hostname, system, username }:
darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit inputs hostname system username;
  };
  modules = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
    ({ config, lib, ... }: {
      options.features.gamesDir = lib.mkEnableOption "the user games application directory";

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit inputs hostname system username;
        inherit (config) features;
      };
      home-manager.users.${username} = { lib, ... }: {
        imports = [
          ../modules/home
        ];
        # Home Manager on Darwin can otherwise leave homeDirectory as null.
        home.username = lib.mkForce username;
        home.homeDirectory = lib.mkForce "/Users/${username}";
      };
    })
    ../hosts/${hostname}
  ];
}
