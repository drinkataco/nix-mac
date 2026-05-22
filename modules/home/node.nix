{
  lib,
  pkgs,
  config,
  pnpmSettings,
  ...
}:
let
  nodeVersions = [
    "20"
    "22"
    "24"
  ];

  globalNodePackages = [
    "lighthouse"
    "@openai/codex"
    "@zed-industries/codex-acp"
  ];

  pnpm = "${pkgs.pnpm}/bin/pnpm";
in
{
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/share/fnm/aliases/default/bin"
  ];

  home.activation.installFnmNodeVersions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.fnm}/bin:$PATH"

    ${lib.concatMapStringsSep "\n" (version: ''
      fnm install ${version}
    '') nodeVersions}

    fnm default 24
  '';

  home.activation.installGlobalNodeTools = lib.hm.dag.entryAfter [ "installFnmNodeVersions" ] ''
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME/bin:${pkgs.pnpm}/bin:$PATH"

    mkdir -p "$PNPM_HOME/bin"

    for package in ${lib.escapeShellArgs globalNodePackages}; do
      if ! "${pnpm}" list -g --depth=0 2>/dev/null | grep -Fq " ''${package}@"; then
        "${pnpm}" add -g --config.ignore-scripts=false --config.optional=true "$package"
      elif [ "${lib.boolToString pnpmSettings.autoUpgrade}" = true ]; then
        "${pnpm}" update -g --latest --config.ignore-scripts=false --config.optional=true "$package"
      fi
    done
  '';
}
