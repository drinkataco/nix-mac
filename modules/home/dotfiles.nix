{ config, lib, ... }:
let
  repoDir = "${config.home.homeDirectory}/projects/nix-mac";
  repoDotfilesDir = "${repoDir}/dotfiles";
  mkSource = path: config.lib.file.mkOutOfStoreSymlink "${repoDotfilesDir}/${path}";

  # Exceptions are for paths that need behaviour beyond the default direct
  # symlink. Karabiner can leave generated/runtime files behind, so force lets
  # Home Manager replace stale managed paths during rebuilds.
  exceptions = {
    ".config/karabiner" = {
      source = mkSource ".config/karabiner";
      force = true;
    };
  };

  mkEntry = path: attrs: {
    name = path;
    value = attrs // {
      source = mkSource path;
    };
  };

  # Paths listed here have custom Home Manager behaviour, so the recursive
  # discovery below must not also emit child entries for them.
  isExceptionPath = path: lib.hasAttr path exceptions;
  isUnderException =
    path: lib.any (parent: lib.hasPrefix "${parent}/" path) (lib.attrNames exceptions);

  # Discover files recursively, but never manage ordinary directories as link
  # targets. That lets Home Manager create/update file links inside existing
  # directories without trying to replace the directories themselves.
  collectEntries =
    prefix: dir:
    lib.flatten (
      lib.mapAttrsToList (
        name: type:
        let
          path = if prefix == "" then name else "${prefix}/${name}";
        in
        if isExceptionPath path || isUnderException path then
          [ ]
        else if type == "directory" then
          collectEntries path (dir + "/${name}")
        else if type == "regular" || type == "symlink" then
          [ (mkEntry path { }) ]
        else
          [ ]
      ) (builtins.readDir dir)
    );

  # Add one entry for each explicit exception. Karabiner is a directory because
  # its runtime-generated files make per-file recursive management noisy.
  exceptionEntries = lib.mapAttrsToList (path: attrs: mkEntry path attrs) exceptions;
in
{
  home.activation.ensureNixMacDotfilesCheckout = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    if [ ! -d ${lib.escapeShellArg repoDotfilesDir} ]; then
      echo "Expected dotfiles at ${repoDotfilesDir}" >&2
      echo "Clone this repo to ${repoDir} or rerun scripts/provision.sh with --repo-dir ${repoDir}." >&2
      exit 1
    fi
  '';

  home.file = builtins.listToAttrs (collectEntries "" ../../dotfiles ++ exceptionEntries);
}
