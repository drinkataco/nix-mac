{ fetchurl, lib, stdenvNoCC, undmg }:

stdenvNoCC.mkDerivation rec {
  pname = "scarlett-mixcontrol";
  version = "1.10.6";

  src = fetchurl {
    url = "https://fael-downloads-prod.focusrite.com/customer/prod/s3fs-public/downloads/Scarlett%20MixControl-1.10.6.dmg";
    sha256 = "8a488fed72686a2a6816854f0168d49745de1ac84713001df32b3023facc251e";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R "Scarlett MixControl.app" "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    description = "Focusrite Scarlett MixControl";
    homepage = "https://fael-downloads-prod.focusrite.com/customer/prod/s3fs-public/downloads/Scarlett%20MixControl-1.10.6.dmg";
    platforms = lib.platforms.darwin;
  };
}
