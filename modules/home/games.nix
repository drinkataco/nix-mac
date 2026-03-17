{ lib, ... }:
{
  home.activation.syncGamesFolder =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      games_dir="$HOME/Applications/Games"
      steam_common="$HOME/Library/Application Support/Steam/steamapps/common"

      mkdir -p "$games_dir"

      if [ -d "$steam_common" ]; then
        # Remove stale symlinks that point at previously installed Steam apps.
        find "$games_dir" -maxdepth 1 -type l | while IFS= read -r link; do
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
          ln -sfn "$app" "$games_dir/$(basename "$app")"
        done
      fi
    '';
}
