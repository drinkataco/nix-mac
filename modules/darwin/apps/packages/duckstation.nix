{
  fetchurl,
  lib,
  stdenvNoCC,
  unzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "duckstation";
  version = "0.1-11295";

  src = fetchurl {
    url = "https://github.com/stenzek/duckstation/releases/download/v${version}/duckstation-mac-release.zip";
    hash = "sha256-e3DtH0tZReyg780W1aJsNraHExq4ktqgQARLfOrzMac=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R DuckStation.app "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    description = "PlayStation 1 emulator";
    homepage = "https://github.com/stenzek/duckstation";
    platforms = lib.platforms.darwin;
  };
}
