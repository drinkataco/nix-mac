{ lib, ... }:
let
  dotfilesDir = ../../dotfiles;
  mkDotfileEntry = name: type:
    if type == "directory" then {
      name = name;
      value = {
        source = dotfilesDir + "/${name}";
        recursive = true;
      };
    } else if type == "regular" || type == "symlink" then {
      name = name;
      value.source = dotfilesDir + "/${name}";
    } else
      null;
in {
  home.file = builtins.listToAttrs (
    builtins.filter (entry: entry != null) (
      lib.mapAttrsToList mkDotfileEntry (builtins.readDir dotfilesDir)
    )
  );
}
