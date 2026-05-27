{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.my.codedb;
  codedb = pkgs.stdenv.mkDerivation rec {
    pname = "codedb";
    version = "0.2.5820";
    src = pkgs.fetchurl {
      url = "https://github.com/justrach/codedb/releases/download/v${version}/codedb-darwin-arm64";
      sha256 = "0c71251067bcca0879991bf479b8be3a1186df5dd6fdf84b9a8164878a5e0423";
    };
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/codedb
      chmod +x $out/bin/codedb
    '';
    meta = {
      description = "Code intelligence MCP server";
      homepage = "https://github.com/justrach/codedb";
      platforms = [ "aarch64-darwin" ];
    };
  };
in {
  options.my.codedb.enable = mkEnableOption "codedb code intelligence MCP server";

  config = mkIf cfg.enable {
    home.packages = [ codedb ];
  };
}
