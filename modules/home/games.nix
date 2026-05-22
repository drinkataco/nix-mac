{ lib, ... }:
{
  home.activation.syncGamesFolder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    games_dir="$HOME/Applications/Games"
    steam_common="$HOME/Library/Application Support/Steam/steamapps/common"

    mkdir -p "$games_dir"

    # Keep non-Steam game apps in the same Dock stack without moving the real
    # app bundle away from Homebrew-managed /Applications.
    for app in "/Applications/PCSX2.app"; do
      if [ -d "$app" ]; then
        ln -sfn "$app" "$games_dir/$(basename "$app")"
      fi
    done

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
