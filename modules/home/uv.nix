{
  lib,
  pkgs,
  uvSettings,
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
  activationPath = lib.makeBinPath [
    pkgs.git
    pkgs.python3
    pkgs.uv
  ];
in
{
  home.activation.installGlobalUvTools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${uvBinDir}:${activationPath}:$PATH:/usr/bin:/bin"
    export UV_PYTHON_PREFERENCE=system

    mkdir -p "${uvBinDir}"

    ${lib.concatMapStringsSep "\n" (tool: ''
      if [ -x "${uvBinDir}/${tool.name}" ]; then
        if [ "${lib.boolToString uvSettings.autoUpgrade}" = true ]; then
          "${uv}" tool upgrade ${lib.escapeShellArg tool.name} >/dev/null 2>&1 \
            || "${uv}" tool install ${lib.escapeShellArg tool.package}
        fi
      else
        "${uv}" tool install ${lib.escapeShellArg tool.package}
      fi
    '') globalUvTools}
  '';
}
