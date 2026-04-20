{
  system.defaults.finder = {
    AppleShowAllExtensions = false;
    FXEnableExtensionChangeWarning = false;
    FXPreferredViewStyle = "clmv";
    NewWindowTarget = "Home";
    QuitMenuItem = true;
    AppleShowAllFiles = false;
    ShowMountedServersOnDesktop = true;
    ShowPathbar = true;
    ShowStatusBar = true;
  };

  system.defaults.CustomUserPreferences."com.apple.finder" = {
    # Favorite tags populate Finder's right-click shortcut menu. Keep this
    # empty to remove the tag colours from file/folder context menus.
    FavoriteTagNames = [ ];
    ShowRecentTags = false;
  };
}
