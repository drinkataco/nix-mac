{ lib, pkgs, ... }:
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
  home.activation.installFnmNodeVersions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.fnm}/bin:$PATH"

    ${lib.concatMapStringsSep "\n" (version: ''
      fnm install ${version}
    '') nodeVersions}

    fnm default 24
  '';

  home.activation.installGlobalNodeTools = lib.hm.dag.entryAfter [ "installFnmNodeVersions" ] ''
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:${pkgs.pnpm}/bin:$PATH"

    mkdir -p "$PNPM_HOME"

    outdated_json="$("${pnpm}" outdated -g --format json 2>/dev/null || true)"

    for package in ${lib.escapeShellArgs globalNodePackages}; do
      if ! "${pnpm}" list -g --depth=0 2>/dev/null | grep -Fq " ''${package}@"; then
        "${pnpm}" add -g --config.ignore-scripts=false --config.optional=true "$package"
      elif printf '%s' "$outdated_json" | "${pkgs.jq}/bin/jq" -e --arg package "$package" '
        if type == "array" then
          any(.[]?; .name? == $package)
        elif type == "object" then
          has($package)
        else
          false
        end
      ' >/dev/null 2>&1; then
        "${pnpm}" add -g --config.ignore-scripts=false --config.optional=true "$package@latest"
      fi
    done
  '';
}
