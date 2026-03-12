{ pkgs, ... }:
{
  nix.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "@admin"
    ];
  };

  programs.zsh.enable = true;
}
