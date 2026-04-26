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

  # Keep the login shell on macOS's built-in /bin/zsh rather than a
  # nix-darwin-managed Zsh package.
  programs.zsh.enable = false;
}
