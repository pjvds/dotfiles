{ pkgs, config, lib, ... }:
let cfg = config.my.python; in
{
  options.my.python.enable = lib.mkEnableOption "Python and micromamba";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      python3
      pipx
      pipenv
      micromamba
    ];

    # Session variables for Micromamba
    home.sessionVariables = {
      MAMBA_NO_LOW_SPEED_LIMIT = "1";
    };

    # Declarative Micromamba initialization
    programs.zsh = {
      shellAliases = {
        python = "python3";
        pip    = "pip3";
      };
      initContent = ''
        # Pip user bin (pip install --user)
        export PATH="$PATH:$HOME/Library/Python/$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')/bin"

        # Pipx
        export PATH="$PATH:$HOME/.local/bin"

        # Enable Micromamba shell hook without modifying PROMPT
        # Powerlevel10k has built-in support for the anaconda segment which handles mamba
        if command -v micromamba &>/dev/null; then
          export MAMBA_ROOT_PREFIX="$HOME/.micromamba"
          # Suppress PROMPT modification from mamba; let p10k handle it
          export MAMBA_NO_PROMPT=1
          eval "$(micromamba shell hook --shell zsh)"
        fi
      '';
    };
  };
}
