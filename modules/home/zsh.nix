{ config, pkgs, lib, ... }: 
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  
  # Blacklist of files that cause P10k warnings or are redundant in Nix
  blacklist = [
    "p10k/init.zsh"
    "fzf/init.darwin.zsh"
    "psql/init.darwin.zsh"
    "homebrew/preinit.darwin.zsh"
    "nix/postinit.darwin.zsh"
    "fzf/init.zsh"
    "node/init.zsh" # We'll manage node environment explicitly
  ];

  # Helper to find all relevant .zsh files in the dotfiles directory
  # while respecting platform-specific logic and excluding the blacklist.
  findZshFiles = pattern: let
    # We use builtins.readDir and recursive search starting from ./../../
    # This allows Nix to see the files within the flake's context.
    dotfilesRoot = ./../..;
    
    # Recursively list all files in the dotfiles directory
    allFiles = lib.filesystem.listFilesRecursive dotfilesRoot;
    
    # Filter for files matching the pattern (e.g., "init.zsh" or "init.darwin.zsh")
    matches = file: let 
      relPath = lib.removePrefix "${toString dotfilesRoot}/" (toString file);
      baseName = builtins.baseNameOf (toString file);
    in 
      (lib.hasSuffix "${pattern}.zsh" baseName || lib.hasSuffix "${pattern}.darwin.zsh" baseName)
      && !(lib.hasInfix ".linux.zsh" baseName)
      && !(builtins.elem relPath blacklist)
      && !(lib.hasInfix "/home/" relPath) # Don't source nix-managed home files
      && !(lib.hasPrefix "." relPath);   # Don't source hidden directories
  in
    builtins.filter matches allFiles;

  # Create the source commands for a specific module type (init, aliases, etc.)
  # We use the absolute path in the resulting shell script so it works at runtime.
  mkSourceCommands = type: lib.concatMapStringsSep "\n" (file: let
    relPath = lib.removePrefix "${toString ./../..}/" (toString file);
  in "source ${dotfiles}/${relPath}") (findZshFiles type);


in {
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
      ".." = "cd ..";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 50 ''
        # Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        # Fix for gitstatus initialization (sometimes required in Nix)
        typeset -g POWERLEVEL9K_GITSTATUS_DIR="${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/gitstatus"
        
        # Use a pre-built gitstatusd if available to avoid download/execution issues in Nix
        typeset -g POWERLEVEL9K_GITSTATUS_GITSTATUSD_EXECUTABLE="${pkgs.gitstatus}/bin/gitstatusd"

        # Source p10k theme early to allow configuration to take effect
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '')
      (lib.mkOrder 100 ''
        # Set DOTFILES variable
        export DOTFILES=$HOME/dotfiles
        export DOTFILES_HOME=$DOTFILES

        # Environment settings from old zshrc
        export LANG="en_US.UTF-8"
        export LC_ALL="POSIX"
        
        # History settings
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

        # --- Automated Cohesive Modules (Discovered at build time) ---
        ${mkSourceCommands "preinit"}
        ${mkSourceCommands "init"}
        ${mkSourceCommands "postinit"}
        ${mkSourceCommands "aliases"}

        # --- Manual Overrides & Integrations ---
        
        # Manual Alias definitions to restore Zim Utility functionality
        if [[ -z ''${NO_COLOR} ]]; then
          export CLICOLOR=1
          export LSCOLORS="ExfxcxdxbxGxDxabagacad" 
          alias grep='grep --color=auto'
        fi

        # Exit terminal with qq
        exit_zsh() { exit }
        if [[ $options[zle] = on ]]; then
          zle -N exit_zsh
          bindkey 'qq' exit_zsh
        fi

        # Fix for zsh-cwd error: NO_STATE is already readonly in some environments
        # We ensure it's not set before the plugin loads
        unset NO_STATE 2>/dev/null
        
        # Autoload k8s helper functions
        fpath=($DOTFILES/k8s/functions $fpath)
        autoload -U argo k3d kubectl kubeprintsec minikube
      '')
    ];

    plugins = [
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

    completionInit = ''
      autoload -U compinit && compinit
      zstyle ':completion:*' menu no
    '';
  };

  home.file.".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/p10k/p10k.zsh";

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
