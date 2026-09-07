{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.my.writetext;
  writetext = pkgs.stdenv.mkDerivation rec {
    pname = "writetext";
    version = "0.2.1";
    src = pkgs.fetchurl {
      url = "https://writetext.io/downloads/WriteText-${version}.dmg";
      sha256 = "4752136f3d8e61d3920386dd0caad74acfc889ffcbbd3fd97b9a46a638aeeffd";
    };
    nativeBuildInputs = [ pkgs.undmg ];
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/Applications
      cp -r WriteText.app $out/Applications/
    '';
    meta = {
      description = "Menu bar app that rewrites text in place using your own LLM key";
      homepage = "https://writetext.io";
      platforms = [ "aarch64-darwin" ];
    };
  };
in {
  options.my.writetext.enable = mkEnableOption "WriteText AI rewriting menu bar app";

  config = mkIf cfg.enable {
    home.packages = [ writetext ];
  };
}
