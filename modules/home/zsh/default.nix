{ config, pkgs, lib, ... }:
let
  cfg = config.my.zsh;
in
{
  options.my.zsh.enable = lib.mkEnableOption "zsh with powerlevel10k and plugins";

  config = lib.mkIf cfg.enable {
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
        # Navigation
        ".."    = "cd ..";
        "..."   = "cd ../../";
        "...."  = "cd ../../../";
        "."     = "cd $DOTFILES";
        ".v"    = "cd $DOTFILES && nvim .";

        # Directory jumps
        jd      = "cd ~/Downloads";
        jdf     = "cd $DOTFILES";
        jc      = "cd ~/Code";
        jcd     = "cd ~/Code/deloitte";

        # Shell quality of life
        qq      = "exit";
        ":q"    = "exit";
        rm      = "rm -r";
        tailf   = "tail -f";
        grep    = "grep --color=auto";

        # z directory jumper
        zl      = "z -l";
        ze      = "nvim ~/.z";

        # Docker
        d       = "docker";
        dfl     = "docker logs -f";
        dc      = "docker compose";
        dcl     = "dc logs -f";
        dcu     = "dc up -d";
        dcfl    = "dc logs -f";
        dcps    = "dc ps";
        ctop    = "docker run --rm -ti --name=ctop -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest";
        rclone  = "docker run --volume ~/.config/rclone:/config/rclone --rm rclone/rclone:latest";

        # Deloitte convenience
        dl      = ''firefox "ext+container:name=Deloite%20-%20Admin&url=https://aka.ms/devicelogin"'';
      };

      initContent = lib.mkMerge [
        (lib.mkOrder 50 ''
          # Powerlevel10k instant prompt — must be at the very top of initContent
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi

          typeset -g POWERLEVEL9K_GITSTATUS_DIR="${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/gitstatus"
          typeset -g POWERLEVEL9K_GITSTATUS_GITSTATUSD_EXECUTABLE="${pkgs.gitstatus}/bin/gitstatusd"

          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '')

        (lib.mkOrder 100 ''
          # Dotfiles root
          export DOTFILES=$HOME/dotfiles
          export DOTFILES_HOME=$DOTFILES
          export PATH="$PATH:$DOTFILES_HOME/bin"

          # Locale
          export LANG="en_US.UTF-8"
          export LC_ALL="POSIX"

          # Colors
          export CLICOLOR=1
          export LSCOLORS="ExfxcxdxbxGxDxabagacad"

          # ZSHZ — jump to uncommon subdirs instead of most-visited child
          export ZSHZ_UNCOMMON=1

          # tunl: copy public addresses by default
          export TUNL_COPY_ADDRESS=1

          # History setopt
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

          # Keybindings
          bindkey "^k" history-beginning-search-backward
          bindkey "^j" history-beginning-search-forward
          bindkey -s '^f' 'fg^M'

          # Copy full path of file/dir to clipboard
          function cpath {
            local p=''${PWD}
            [[ -n "$1" ]] && p=$(realpath "$1")
            if type xclip &>/dev/null; then
              echo -n "$p" | xclip -selection clipboard
            else
              echo -n "$p" | pbcopy
            fi
            echo "copied $p"
          }
          bindkey -s '^y' "cpath"
          bindkey -s 'yp' 'cpath'

          # Copy current directory path to clipboard
          function cdir {
            local path=$(pwd)
            if type xclip &>/dev/null; then
              echo -n "$path" | xclip -selection clipboard
            else
              echo -n "$path" | pbcopy
            fi
            echo "copied $path"
          }

          # Source a .env file and show the diff
          function senv {
            local file=$([ -z "$1" ] && echo ".env" || echo "$1.env")
            [[ ! -f "$file" ]] && { echo "$file not found" >&2; return 1; }
            local tmp=$(mktemp -d)
            export > "$tmp/before"
            set -a; source "$file"; set +a
            export > "$tmp/after"
            sdiff "$tmp/before" "$tmp/after"
          }

          # Create dir and cd into it
          function mkcd { mkdir -p "$1" && cd "$1"; }

          # Enhanced ls (sort by date in Downloads)
          unalias ll 2>/dev/null
          function ll {
            if [[ "$PWD" == "$HOME/Downloads" ]]; then
              ls -lAh -Utr
            else
              ls -lah
            fi
          }
          alias l=ll

          # Docker: print IP of a container
          function dip {
            docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
          }

          # Docker: run lazydocker
          alias lzd='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v /yourpath/config:/.config/jesseduffield/lazydocker lazyteam/lazydocker'

          # Get the KID (key identifier) of a certificate's public key
          function kid {
            local CRT_FILE="$1"
            local DER_FILE=$(mktemp)
            openssl x509 -in "$CRT_FILE" -pubkey -noout 2>/dev/null | openssl rsa -pubin -outform DER -out "$DER_FILE" 2>/dev/null
            local SHA256_HASH=$(openssl dgst -sha256 -binary "$DER_FILE" 2>/dev/null | xxd -p -c 256)
            echo -n "$SHA256_HASH" | xxd -r -p | base64 | tr '+/' '-_' | tr -d '='
            rm "$DER_FILE"
          }

          # Fix for zsh-cwd: NO_STATE may already be readonly in some environments
          unset NO_STATE 2>/dev/null
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

    # p10k config — stays at repo root in modules/home/zsh/config/
    home.file.".p10k.zsh".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/modules/home/zsh/config/p10k.zsh";

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
