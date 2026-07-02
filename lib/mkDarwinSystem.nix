{
  inputs,
  darwin,
  hostname,
  system,
  username,
}:
darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit
      inputs
      hostname
      system
      username
      ;
  };
  modules = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
    (
      { config, lib, ... }:
      {
        options = {
          features.gamesDir = lib.mkEnableOption "the user games application directory";

          pnpm.autoUpgrade = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Upgrade global pnpm tools during Home Manager activation.";
          };

          uv.autoUpgrade = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Upgrade global uv tools during Home Manager activation.";
          };

          projects.dirName = lib.mkOption {
            type = lib.types.str;
            default = "projects";
            description = "Name of the projects directory created under the user's home.";
          };
        };

        config = {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # When a managed path drifted into a real file, move it aside instead of
            # aborting the whole switch. This keeps Home Manager recoverable after
            # direct edits under $HOME.
            backupFileExtension = "hm-bak";
            extraSpecialArgs = {
              inherit
                inputs
                hostname
                system
                username
                ;
              inherit (config) features;
              pnpmSettings = config.pnpm;
              uvSettings = config.uv;
            };
            users.${username} =
              { lib, ... }:
              {
                imports = [
                  ../modules/home
                ];
                # Home Manager on Darwin can otherwise leave homeDirectory as null.
                home.username = lib.mkForce username;
                home.homeDirectory = lib.mkForce "/Users/${username}";
              };
          };
        };
      }
    )
    ../hosts/${hostname}
  ];
}
