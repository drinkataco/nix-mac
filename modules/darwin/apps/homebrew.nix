{
  config,
  inputs,
  lib,
  username,
  ...
}:
{
  imports = [
    (lib.mkAliasOptionModule [ "homebrew" "cleanUp" ] [ "homebrew" "onActivation" "cleanup" ])
    (lib.mkAliasOptionModule [ "homebrew" "autoUpgrade" ] [ "homebrew" "onActivation" "upgrade" ])
    (lib.mkAliasOptionModule [ "homebrew" "mutableTaps" ] [ "nix-homebrew" "mutableTaps" ])
  ];

  nix-homebrew = {
    autoMigrate = true;
    enable = true;
    enableRosetta = false;
    mutableTaps = lib.mkDefault false;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    user = username;
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;

    onActivation = {
      autoUpdate = lib.mkDefault false;
      cleanup = lib.mkDefault "none";
      upgrade = lib.mkDefault true;
    };

    # CLI tools with no nixpkgs/binary-cache path — use the prebuilt bottle
    # instead of building from source (herdr was a from-source flake input)
    brews = [
      "herdr" # Agent multiplexer (herdr.dev); homebrew-core bottle, no compile
      "unar" # Unarchiver CLI; bottle avoids a broken from-source nix build
      "mkvtoolnix" # Matroska CLI tools; bottle avoids a slow from-source build
    ];

    # These apps are installed on every host. For host-specific apps, add
    #  `homebrew.casks = [ ... ];` in the relevant host module
    # Keep GUI apps in Homebrew so they have stable /Applications paths
    casks = [
      # Fonts
      "font-fira-code-nerd-font"
      "font-hack-nerd-font"
      "font-inconsolata-go-nerd-font"
      "font-inconsolata-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-meslo-lg-nerd-font"
      "font-symbols-only-nerd-font"

      # Browsers
      "firefox"
      "google-chrome"

      # Productivity and communication
      "chatgpt"
      "claude"
      "claude-code"
      "codex-app"
      "google-drive"
      "notion"
      "slack"
      "spotify"

      # Desktop utilities
      "amethyst"
      "karabiner-elements"
      "flux-app"
      "keepassxc"
      "little-snitch"
      #"paragon-extfs"
      "protonvpn"

      # Media and hardware tools
      "handbrake-app"
      "raspberry-pi-imager"
      "utm"
      "vlc"

      # Developer tools
      "rancher"
      "sequel-ace"
      "sublime-text"
    ];
  };

  system.activationScripts.postActivation.text = lib.mkAfter ''
    mkdir -p /Users/${username}/.local/bin
    ln -sf /opt/homebrew/bin/claude /Users/${username}/.local/bin/claude
  '';
}
