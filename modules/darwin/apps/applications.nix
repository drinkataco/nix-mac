{ config, pkgs, ... }:
let
  systemApplications = pkgs.buildEnv {
    name = "system-applications";
    paths = config.environment.systemPackages;
    pathsToLink = [ "/Applications" ];
  };
in
{
  # Surface Nix-provided app bundles under a stable Finder/Dock path.
  system.activationScripts.applications.text = ''
    echo "setting up /Applications/Nix Apps..." >&2
    rm -rf "/Applications/Nix Apps"
    mkdir -p "/Applications/Nix Apps"

    find "${systemApplications}/Applications" -maxdepth 1 -type l | while read -r app_link; do
      app_target="$(readlink "$app_link")"
      app_name="$(basename "$app_target")"
      ${pkgs.mkalias}/bin/mkalias "$app_target" "/Applications/Nix Apps/$app_name"
    done
  '';
}
