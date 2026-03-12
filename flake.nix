{
  description = "macOS configuration managed with nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { darwin, ... }: let
    mkDarwinSystem = import ./lib/mkDarwinSystem.nix;
  in {
    darwinConfigurations.watts = mkDarwinSystem {
      inherit darwin;
      hostname = "watts";
      system = "aarch64-darwin";
    };
  };
}
