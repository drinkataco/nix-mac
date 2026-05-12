{ lib, pkgs, ... }:
let
  globalUvTools = [
    {
      name = "skills-ref";
      package = "git+https://github.com/agentskills/agentskills#subdirectory=skills-ref";
    }
  ];

  uv = "${pkgs.uv}/bin/uv";
  uvBinDir = "$HOME/.local/bin";
in
{
  home.activation.installGlobalUvTools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${uvBinDir}:${pkgs.uv}/bin:$PATH"

    mkdir -p "${uvBinDir}"

    ${lib.concatMapStringsSep "\n" (tool: ''
      if [ -x "${uvBinDir}/${tool.name}" ]; then
        "${uv}" tool upgrade ${lib.escapeShellArg tool.name} >/dev/null 2>&1 \
          || "${uv}" tool install ${lib.escapeShellArg tool.package}
      else
        "${uv}" tool install ${lib.escapeShellArg tool.package}
      fi
    '') globalUvTools}
  '';
}
