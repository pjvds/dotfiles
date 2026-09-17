{ pkgs, config, lib, ... }:
let cfg = config.my.atuin; in
{
  options.my.atuin.enable = lib.mkEnableOption "atuin shell history";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.atuin ];

    # Remove stale symlink left over from the old mkOutOfStoreSymlink setup.
    # Only removes the path if it is a symlink — never touches a real directory
    # (which would contain the sync key and auth token).
    home.activation.cleanAtuinSymlink = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      if [ -L "${config.home.homeDirectory}/.config/atuin" ]; then
        rm "${config.home.homeDirectory}/.config/atuin"
      fi
    '';

    programs.atuin = {
      enable = true;
      # home-manager's own zsh integration runs `eval "$(atuin init zsh)"`
      # synchronously in initContent, which forks the atuin binary (and its
      # own nested `atuin uuid` call) on every shell startup (~94ms measured
      # via zsh -x timing). Defer the equivalent init ourselves below,
      # matching the pattern already used for fnm/pyenv.
      enableZshIntegration = false;
      forceOverwriteSettings = true;
      settings = {
        style        = "full";
        enter_accept = true;
        sync.records = true;
        daemon.enabled = true;
        daemon.auto_start = true;
        # do not store failed commands
        store_failed = false;
        # Up arrow only searches the current shell session's history;
        # Ctrl-r / down arrow still search globally across all sessions.
        filter_mode = "global";
        filter_mode_shell_up_key_binding = "session";
      };
    };

    programs.zsh.initContent = ''
      # Defer atuin initialization to speed up shell startup (see enableZshIntegration above)
      _init_atuin() {
        if [[ $options[zle] = on ]]; then
          eval "$(${pkgs.atuin}/bin/atuin init zsh)"
          # Down arrow opens the interactive global search (atuin only binds
          # up arrow by default); up arrow keeps its default binding and
          # honors filter_mode_shell_up_key_binding = "session" above.
          # Bound in both viins and vicmd keymaps (this config uses zsh vi
          # mode), since a plain `bindkey` only affects whichever keymap
          # happens to be active at eval time.
          bindkey -M viins '^[[B' atuin-search-viins
          bindkey -M viins '^[OB' atuin-search-viins
          bindkey -M vicmd '^[[B' atuin-search-vicmd
          bindkey -M vicmd '^[OB' atuin-search-vicmd
        fi
      }
      zsh-defer _init_atuin
    '';

    launchd.agents.atuin-daemon = {
      enable = true;
      config = {
        Label = "com.github.atuinsh.atuin.daemon";
        # The atuin daemon sometimes leaves its unix socket behind when killed/restarted.
        # This causes the new daemon instance to crash with "Address already in use (os error 48)".
        # We explicitly remove the socket before starting to ensure clean restarts during system updates.
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "rm -f ${config.home.homeDirectory}/.local/share/atuin/atuin.sock && exec ${pkgs.atuin}/bin/atuin daemon start"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "${config.home.homeDirectory}/.local/share/atuin/daemon.log";
        StandardErrorPath = "${config.home.homeDirectory}/.local/share/atuin/daemon-error.log";
      };
    };
  };
}
