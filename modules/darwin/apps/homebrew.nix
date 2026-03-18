{ username, ... }:
{
  nix-homebrew = {
    autoMigrate = true;
    enable = true;
    enableRosetta = false;
    user = username;
  };

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "none";
      upgrade = false;
    };

    # Keep GUI apps in Homebrew so they have stable /Applications paths.
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
      "codex"
      "google-drive"
      "notion"
      "slack"
      "spotify"

      # Desktop utilities
      "alacritty"
      "amethyst"
      "karabiner-elements"
      "flux-app"
      "keepassxc"
      "little-snitch"
      "paragon-extfs"
      "protonvpn"

      # Media and hardware tools
      "handbrake-app"
      "raspberry-pi-imager"
      "steam"
      "utm"
      "vlc"

      # Developer tools
      "rancher"
      "sequel-ace"
      "sublime-text"
    ];
  };
}
