{
  config,
  lib,
  pkgs,
  ...
}:
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
  options.uv.autoUpgrade = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Upgrade global uv tools during Home Manager activation.";
  };

  home.activation.installGlobalUvTools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${uvBinDir}:${pkgs.git}/bin:${pkgs.python3}/bin:${pkgs.uv}/bin:/usr/bin:/bin:$PATH"
    export UV_PYTHON_PREFERENCE=system

    mkdir -p "${uvBinDir}"

    ${lib.concatMapStringsSep "\n" (tool: ''
      if [ -x "${uvBinDir}/${tool.name}" ]; then
        if [ "${lib.boolToString config.uv.autoUpgrade}" = true ]; then
          "${uv}" tool upgrade ${lib.escapeShellArg tool.name} >/dev/null 2>&1 \
            || "${uv}" tool install ${lib.escapeShellArg tool.package}
        fi
      else
        "${uv}" tool install ${lib.escapeShellArg tool.package}
      fi
    '') globalUvTools}
  '';
}
