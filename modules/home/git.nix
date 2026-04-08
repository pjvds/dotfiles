{ config, pkgs, lib, ... }:
let cfg = config.my.git; in
{
  options.my.git.enable = lib.mkEnableOption "git configuration";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      signing.format = null;

      settings = {
        user = {
          name = "Pieter Joost van de Sande";
          email = "pj@born2code.net";
        };

        core = {
          editor = "nvim";
          autocrlf = "input";
        };
        color = {
          ui = "auto";
        };
        merge = {
          tool = "fugitive";
          conflictstyle = "diff3";
        };
        "mergetool \"fugitive\"" = {
          cmd = "nvim -f -c \"Gvdiffsplit!\" \"$MERGED\"";
        };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        pull = {
          rebase = true;
        };
        rebase = {
          autoStash = true;
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
        diff = {
          submodule = "log";
        };
        status = {
          submoduleSummary = true;
        };
        maintenance = {
          repo = "~/code/deloitte/xray/backend";
        };
      };

      # Global excludes
      ignores = [
        ".DS_Store"
        "result"
      ];

      # Include platform/context specific configs inline
      includes = [
        {
          condition = "gitdir/i:~/code/deloitte/";
          contents = {
            user = {
              email = "pvandesande@deloitte.nl";
            };
          };
        }
        {
          condition = "gitdir/i:~/code/born2code/";
          contents = {
            user = {
              email = "pj@born2code.net";
            };
          };
        }
      ];
    };

    programs.zsh.shellAliases = {
      ga    = "git add -p";
      gap   = "git add -p";
      gc    = "git commit --verbose";
      "gc!" = "git commit --amend --verbose";
      "gcne!" = "git commit --amend --no-edit";
      "gp!" = "git push --force";
      gd    = "git diff";
      gs    = "git status";
      gcm   = "git commit -m";
      gfa   = "git fetch --all";
      gco   = "git checkout";
      gcob  = "git checkout -b";
      gpl   = "git pull";
      gp    = "git push";
      gpu   = ''git push -u origin $(git branch | grep \* | cut -d ' ' -f2)'';
      gcom  = "git checkout master";
      gcp   = ''git commit -m "$(git status --porcelain)"'';
    };
  };
}
