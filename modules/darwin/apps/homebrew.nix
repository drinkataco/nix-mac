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

    # Keep Dock-pinned GUI apps in Homebrew so they have stable /Applications paths.
    casks = [
      "alacritty"
      "amethyst"
      "chatgpt"
      "flux"
      "firefox"
      "google-chrome"
      "google-drive"
      "handbrake"
      "keepassxc"
      "little-snitch"
      "notion"
      "paragon-extfs"
      "protonvpn"
      "raspberry-pi-imager"
      "rancher"
      "sequel-ace"
      "slack"
      "spotify"
      "steam"
      "sublime-text"
      "utm"
      "vlc"
    ];
  };
}
