{ config, lib, username, ... }:
let
  dir = "/Users/${username}/${config.projects.dirName}";
in
{
  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo "setting up ${dir}..." >&2
    mkdir -p \
      "${dir}/work/_example/repos" \
      "${dir}/work/_example/investigations" \
      "${dir}/work/_example/agents" \
      "${dir}/personal/agents" \
      "${dir}/personal/repos" \
      "${dir}/scratch" \
      "${dir}/study"
  '';
}
