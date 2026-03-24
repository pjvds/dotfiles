{ pkgs, ... }:
let
  dotnet = pkgs.dotnetCorePackages;
in {
  home.packages = [
    (dotnet.combinePackages [
      dotnet.sdk_9_0-bin
      dotnet.sdk_10_0-bin
    ])
  ];

  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };
}
