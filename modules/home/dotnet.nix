{ pkgs, lib, config, ... }:
let
  cfg = config.my.dotnet;
  dotnet = pkgs.dotnetCorePackages;
  dotnetPkg = dotnet.combinePackages [
    dotnet.sdk_9_0-bin
    dotnet.sdk_10_0-bin
  ];
in
{
  options.my.dotnet.enable = lib.mkEnableOption ".NET SDK";

  config = lib.mkIf cfg.enable {
    home.packages = [ dotnetPkg ];

    home.sessionVariables = {
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    };

    programs.zsh.initContent = ''
      export DOTNET_ROOT="${dotnetPkg}/share/dotnet"
      export DOTNET_TOOLS="$HOME/.dotnet/tools"
      export PATH="$PATH:$DOTNET_TOOLS"
    '';
  };
}
