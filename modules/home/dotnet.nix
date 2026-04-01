{ pkgs, lib, config, ... }:
let
  cfg = config.my.dotnet;
  dotnet = pkgs.dotnetCorePackages;
in
{
  options.my.dotnet.enable = lib.mkEnableOption ".NET SDK";

  config = lib.mkIf cfg.enable {
    home.packages = [
      (dotnet.combinePackages [
        dotnet.sdk_9_0-bin
        dotnet.sdk_10_0-bin
      ])
    ];

    home.sessionVariables = {
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    };
  };
}
