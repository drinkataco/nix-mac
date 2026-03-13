{ username, ... }:
{
  system.defaults.dock = {
    autohide = true;
    magnification = false;
    minimize-to-application = true;
    mru-spaces = false;
    persistent-apps = [
      {
        app = "/System/Library/CoreServices/Finder.app";
      }
      {
        spacer = {
          small = false;
        };
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
          arrangement = "date-added";
          displayas = "folder";
          path = "/Applications";
          showas = "grid";
        };
      }
    ];
    show-recents = true;
    tilesize = 48;
  };
}
