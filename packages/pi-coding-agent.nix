{ pkgs, lib, ... }:

let
  version = "0.74.0";
  platform = if pkgs.stdenv.isAarch64 then "arm64" else "x64";
  hashes = {
    "darwin-arm64" = "sha256-MGMXmCPGqYVjQxIkDFcBUCQxb3/mZh7dQfFMd9ixXhA=";
    "darwin-x64" = "sha256-+mXJjyxlHsL4n7Goo9ybmHlHvJsQI2Gi8XiGKrrMdWA=";
  };
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "pi-coding-agent";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/earendil-works/pi/releases/download/v${version}/pi-darwin-${platform}.tar.gz";
    hash = hashes."darwin-${platform}";
  };

  sourceRoot = "pi";

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/lib/pi $out/bin
    cp -r . $out/lib/pi/
    chmod +x $out/lib/pi/pi
    makeWrapper $out/lib/pi/pi $out/bin/pi \
      --run 'export NPM_CONFIG_PREFIX="$HOME/.local"'
  '';

  meta = {
    description = "Interactive coding agent CLI by Mario Zechner";
    homepage = "https://github.com/earendil-works/pi";
    license = lib.licenses.mit;
    mainProgram = "pi";
    platforms = lib.platforms.darwin;
  };
}
