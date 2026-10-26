{ pkgs, lib, config, ... }:
let cfg = config.my.apps; in
{
  options.my.apps.enable = lib.mkEnableOption "GUI applications";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      alt-tab-macos
      aws-vault
      cyberduck
      jetbrains.idea

      protonmail-desktop

      jetbrains.rider
      shottr
    ];

    programs.vscode = {
      enable = true;
      profiles.default = {
        mutableUserSettings = true;
        enableUpdateCheck = false;
      };
    };

    targets.darwin.defaults = {
      "com.lwouis.alt-tab-macos" = {
        SUEnableAutomaticChecks = false;
        SUAutomaticallyUpdate = false;
      };
      "ch.sudo.cyberduck" = {
        SUEnableAutomaticChecks = false;
        SUAutomaticallyUpdate = false;
      };
    };

    # MSSQL extension (Azure Data Studio's successor for SQL Server/Azure SQL work).
    home.activation.installVscodeMssqlExtension = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if ! ${pkgs.vscode}/bin/code --list-extensions 2>/dev/null | grep -q "^ms-mssql.mssql$"; then
        $DRY_RUN_CMD ${pkgs.vscode}/bin/code --install-extension ms-mssql.mssql --force
      fi
    '';
  };
}
