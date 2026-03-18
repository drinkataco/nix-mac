{ config, lib, ... }:
let
  repoDotfilesDir = "${config.home.homeDirectory}/projects/nix-mac/dotfiles";
  mkSource = name: config.lib.file.mkOutOfStoreSymlink "${repoDotfilesDir}/${name}";
  collectDotfileEntries =
    prefix: dir:
    lib.flatten (
      lib.mapAttrsToList (
        name: type:
        let
          relativePath = if prefix == "" then name else "${prefix}/${name}";
        in
        if type == "directory" then
          collectDotfileEntries relativePath (dir + "/${name}")
        else if type == "regular" || type == "symlink" then
          {
            name = relativePath;
            value.source = mkSource relativePath;
          }
        else
          [ ]
      ) (builtins.readDir dir)
    );
in {
  home.file = builtins.listToAttrs (collectDotfileEntries "" ../../dotfiles);
}
