{
  config,
  lib,
  username,
  ...
}:
{
  system.defaults.CustomUserPreferences."com.apple.dock" = {
    "show-recent-count" = 1;
  };

  system.defaults.dock = {
    autohide = true;
    magnification = false;
    minimize-to-application = true;
    mru-spaces = false;
    wvous-br-corner = 1;
    persistent-apps = [
      {
        app = "/Applications/Firefox.app";
      }
      {
        app = "/Applications/Spotify.app";
      }
      {
        app = "/Applications/Nix Apps/Alacritty.app";
      }
      {
        app = "/Applications/Claude.app";
      }
      {
        app = "/Applications/ChatGPT Classic.app";
      }
      {
        app = "/Applications/Notion.app";
      }
      {
        app = "/Applications/KeePassXC.app";
      }
      {
        app = "/Applications/Rancher Desktop.app";
      }
    ];
    persistent-others = [
      {
        folder = {
          arrangement = "date-added";
          displayas = "folder";
          path = "/Users/${username}/Downloads";
          showas = "grid";
        };
      }
      {
        folder = {
          arrangement = "name";
          displayas = "folder";
          path = "/Applications";
          showas = "grid";
        };
      }
    ]
    ++ lib.optionals config.features.gamesDir [
      {
        folder = {
          arrangement = "name";
          displayas = "folder";
          path = "/Users/${username}/Applications/Games";
          showas = "grid";
        };
      }
    ];
    show-recents = true;
    tilesize = 48;
  };
}
