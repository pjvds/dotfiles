{ pkgs, ... }: {
  home.packages = [ pkgs.dotnetCorePackages.sdk_10_0-bin ];

  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };
}
