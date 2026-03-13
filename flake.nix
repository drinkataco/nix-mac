{
  description = "macOS configuration managed with nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { darwin, ... }: let
    mkDarwinSystem = import ./lib/mkDarwinSystem.nix;
    username = "osh";
  in {
    darwinConfigurations.watts = mkDarwinSystem {
      inherit darwin;
      inherit username;
      hostname = "watts";
      system = "aarch64-darwin";
    };
  };
}
