{ config, pkgs, ... }: {
  programs.git = {
    enable = true;

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
}
