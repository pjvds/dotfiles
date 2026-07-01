{ pkgs, lib, config, ... }:
let
  cfg = config.my.dotnet;
  user = config.system.primaryUser;
  dotnet = pkgs.dotnetCorePackages;
  dotnetPkg = dotnet.combinePackages [
    dotnet.sdk_9_0-bin
    dotnet.sdk_10_0-bin
  ];
in
{
  options.my.dotnet.enable = lib.mkEnableOption ".NET development (SDK and Aspire)";

  config = lib.mkIf cfg.enable {
    # Aspire dashboard requires homebrew
    homebrew.taps = [ "microsoft/aspire" ];
    homebrew.casks = [ "microsoft/aspire/aspire" ];

    home-manager.users.${user} = { ... }: {
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
  };
}
