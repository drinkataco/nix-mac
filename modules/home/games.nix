{ lib, ... }:
{
  home.activation.syncGamesFolder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    games_dir="$HOME/Applications/Games"
    steam_dir="$games_dir/Steam"
    steam_common="$HOME/Library/Application Support/Steam/steamapps/common"

    mkdir -p "$games_dir" "$steam_dir"

    # Emulator launchers sit at the top level of the Games folder.
    for app in "/Applications/PCSX2.app" "/Applications/Nix Apps/DuckStation.app"; do
      if [ -d "$app" ]; then
        ln -sfn "$app" "$games_dir/$(basename "$app")"
      fi
    done

    # Steam launcher lives inside the Steam folder alongside its games.
    if [ -d "/Applications/Steam.app" ]; then
      ln -sfn "/Applications/Steam.app" "$steam_dir/Steam.app"
    fi

    if [ -d "$steam_common" ]; then
      # Remove all Steam symlinks from the top-level dir (migrates old links
      # into steam/) and remove stale ones from steam/.
      find "$games_dir" "$steam_dir" -maxdepth 1 -type l | while IFS= read -r link; do
        target="$(readlink "$link" || true)"
        case "$target" in
          "$steam_common"/*)
            parent="$(dirname "$link")"
            if [ "$parent" = "$games_dir" ] || [ ! -e "$target" ]; then
              rm -f "$link"
            fi
            ;;
        esac
      done

      find "$steam_common" -maxdepth 2 -name '*.app' | while IFS= read -r app; do
        ln -sfn "$app" "$steam_dir/$(basename "$app")"
      done
    fi
  '';
}
