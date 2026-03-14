{
  description = "macOS configuration managed with nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ darwin, ... }: let
    mkDarwinSystem = import ./lib/mkDarwinSystem.nix;
    username = "osh";
  in {
    darwinConfigurations.watts = mkDarwinSystem {
      inherit inputs;
      inherit darwin;
      inherit username;
      hostname = "watts";
      system = "aarch64-darwin";
    };
  };
}
