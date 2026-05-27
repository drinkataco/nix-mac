{ lib, ... }:
{
  home.activation.syncGamesFolder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    games_dir="$HOME/Applications/Games"
    steam_dir="$games_dir/Steam"
    steam_common="$HOME/Library/Application Support/Steam/steamapps/common"

    mkdir -p "$games_dir" "$steam_dir"

    # Keep platform launchers at the top level so the Dock stack starts with
    # the launcher apps, then group platform-owned games below them.
    for app in "/Applications/Steam.app" "/Applications/PCSX2.app"; do
      if [ -d "$app" ]; then
        ln -sfn "$app" "$games_dir/$(basename "$app")"
      fi
    done

    if [ -d "$steam_common" ]; then
      # Remove stale symlinks that point at previously installed Steam apps.
      find "$games_dir" "$steam_dir" -maxdepth 1 -type l | while IFS= read -r link; do
        target="$(readlink "$link" || true)"
        case "$target" in
          "$steam_common"/*)
            if [ ! -e "$target" ]; then
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
