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

    hosts = {
      watts = {
        username = "osh";
        system = "aarch64-darwin";
      };

      work = {
        username = "osh";
        system = "aarch64-darwin";
      };
    };
  in {
    darwinConfigurations = builtins.mapAttrs
      (hostname: host:
        mkDarwinSystem {
          inherit inputs darwin hostname;
          inherit (host) username system;
        })
      hosts;
  };
}
