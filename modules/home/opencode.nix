{ config, pkgs, lib, ... }:
let cfg = config.my.opencode; in
{
  options.my.opencode.enable = lib.mkEnableOption "OpenCode AI editor configuration";

  config = lib.mkIf cfg.enable {
    # OpenCode AI editor configuration
    # Symlinks the entire opencode directory to ~/.config/opencode
    # Using mkOutOfStoreSymlink so that edits to AGENTS.md, themes, etc.
    # are reflected immediately without a Nix rebuild.
    home.file.".config/opencode".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/opencode";

    # Skills dependencies + secret management
    home.packages = [
      # Obsidian CLI wrapper — bunx -y ensures no interactive prompt in non-interactive shells
      (pkgs.writeShellScriptBin "obsidian" ''bunx -y obsidian-cli "$@"'')

      # defuddle-cli wrapper — pkgs.defuddle-cli is currently broken in nixpkgs (out-of-sync lockfile)
      (pkgs.writeShellScriptBin "defuddle" ''bunx -y defuddle-cli "$@"'')

      # Proton Pass CLI — secret injection via pass-cli run
      pkgs.proton-pass-cli
    ];

    # Keep obsidian-skills submodule up to date on every home-manager switch
    home.activation.updateOpencodeSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      cd ${config.home.homeDirectory}/dotfiles
      ${pkgs.git}/bin/git submodule update --init --recursive --remote opencode/skills/obsidian-skills
    '';
  };
}
