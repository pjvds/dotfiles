{ config, pkgs, lib, ... }:
let cfg = config.my.opencode; in
{
  options.my.opencode.enable = lib.mkEnableOption "OpenCode AI editor configuration";

  config = lib.mkIf cfg.enable {
    home.file.".config/opencode".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/home/opencode/config";

    home.packages = [
      # bun runtime — required for the bunx wrappers below
      pkgs.bun

      # Obsidian CLI wrapper — bunx -y ensures no interactive prompt in non-interactive shells
      (pkgs.writeShellScriptBin "obsidian" ''bunx -y obsidian-cli "$@"'')

      # defuddle-cli wrapper — pkgs.defuddle-cli is currently broken in nixpkgs (out-of-sync lockfile)
      (pkgs.writeShellScriptBin "defuddle" ''bunx -y defuddle-cli "$@"'')

      # Proton Pass CLI — secret injection via pass-cli run
      pkgs.proton-pass-cli
    ];

    # Keep skills submodule up to date on every home-manager switch
    home.activation.updateSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      cd ${config.home.homeDirectory}/dotfiles
      ${pkgs.git}/bin/git submodule update --init --recursive --remote modules/ai/skills
    '';
  };
}
