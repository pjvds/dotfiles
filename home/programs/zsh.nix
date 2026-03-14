{ config, pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000000;
      save = 10000000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreAllDups = true;
      share = true;
    };

    shellAliases = {
      # Add your core aliases here - we can migrate others later
      # ll = "ls -l"; # Removed to allow legacy function to take precedence
      ".." = "cd ..";
    };

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      (lib.mkAfter ''
        # Post-plugin configuration (including atuin)
        
        # Ensure atuin is initialized after all other plugins (especially zsh-vi-mode)
        if [[ $options[zle] = on ]]; then
          eval "$(atuin init zsh)"
        fi

        # Final p10k source to ensure prompt is correct
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        
        # bun completions
        [ -s "/Users/pvandesande/.bun/_bun" ] && source "/Users/pvandesande/.bun/_bun"
      '')
      ''
        # Set DOTFILES variable
        export DOTFILES=$HOME/dotfiles
        export DOTFILES_HOME=$DOTFILES

        # Environment settings from old zshrc
        export LANG="en_US.UTF-8"
        export LC_ALL="POSIX"
        WORDCHARS=''${WORDCHARS//[\/]}

        # Powerlevel10k config (sourced here and in mkAfter for safety)
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # Vi mode configuration
        bindkey -v
        bindkey 'jj' vi-cmd-mode
        
        # Additional settings
        setopt INTERACTIVE_COMMENTS
        setopt NO_NOMATCH
        setopt BANG_HIST
        
        # Override completion menu for fzf-tab
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
        zstyle ':fzf-tab:*' fzf-command fzf
        setopt EXTENDED_HISTORY
        setopt INC_APPEND_HISTORY
        setopt SHARE_HISTORY
        setopt HIST_EXPIRE_DUPS_FIRST
        setopt HIST_IGNORE_DUPS
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_FIND_NO_DUPS
        setopt HIST_IGNORE_SPACE
        setopt HIST_SAVE_NO_DUPS
        setopt HIST_REDUCE_BLANKS
        setopt HIST_VERIFY
        setopt HIST_BEEP

        # --- Legacy Dotfiles Loader ---
        # This replicates the logic from the old zshrc to support existing modules
        
        # Load custom dotfiles framework
        source $DOTFILES/init.zsh

        # Modules managed by Nix (previously Zim)
        # We skip these in the glob loader to avoid double-loading or conflicts
        NIX_MANAGED_MODULES=(k8s node)

        _is_nix_managed() {
          local file=$1
          for mod in $NIX_MANAGED_MODULES; do
            [[ "$file" == *"/$mod/"* ]] && return 0
          done
          return 1
        }

        # Detect OS once for all platform-specific files
        os="''${$(uname):l}"

        # Sourcing loop for legacy modules (restored from backup)
        for file in $DOTFILES/**/preinit.zsh; do _is_nix_managed "$file" || { [ -f $file ] && source $file }; done
        for file in $DOTFILES/**/preinit.$os.zsh; do _is_nix_managed "$file" || { [ -f $file ] && source $file }; done
        for file in $DOTFILES/**/init.zsh; do _is_nix_managed "$file" || { [ -f $file ] && source $file }; done
        for file in $DOTFILES/**/init.$os.zsh; do _is_nix_managed "$file" || { [ -f $file ] && source $file }; done
        for file in $DOTFILES/**/postinit.zsh; do _is_nix_managed "$file" || { [ -f $file ] && source $file }; done
        for file in $DOTFILES/**/postinit.$os.zsh; do _is_nix_managed "$file" || { [ -f $file ] && source $file }; done
        for file in $DOTFILES/**/aliases.zsh; do _is_nix_managed "$file" || { [ -f $file ] && source $file }; done
        for file in $DOTFILES/**/aliases.$os.zsh; do _is_nix_managed "$file" || { [ -f $file ] && source $file }; done

        # Exit terminal with qq
        exit_zsh() { exit }
        zle -N exit_zsh
        bindkey 'qq' exit_zsh

        # Manual Alias definitions to restore Zim Utility functionality
        if [[ -z ''${NO_COLOR} ]]; then
          export CLICOLOR=1
          export LSCOLORS="ExfxcxdxbxGxDxabagacad" # Restored from Zim Utility BSD section
          alias grep='grep --color=auto'
        fi
      ''
    ];


    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
      {
        name = "zsh-z";
        src = pkgs.zsh-z;
        file = "share/zsh-z/zsh-z.plugin.zsh";
      }
      {
        name = "zsh-cwd";
        src = pkgs.fetchFromGitHub {
          owner = "pjvds";
          repo = "zsh-cwd";
          rev = "master";
          sha256 = "0fgy6yqrmglzr3a20bysiml59wq64bd44lcqkj17fb1y5sag5hd3";
        };
        file = "zsh-cwd.plugin.zsh";
      }
      {
        name = "zsh-cd-print";
        src = pkgs.fetchFromGitHub {
          owner = "pjvds";
          repo = "zsh-cd-print";
          rev = "master";
          sha256 = "0f9hwq9mqxgvykyjy80cyxfnqwblny0b3vkwiryhccsvgcbjmlwv";
        };
      }
    ];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = false; # We'll manage this manually in mkAfter
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
