{ pkgs, config, lib, ... }:
let cfg = config.my.python; in
{
  options.my.python.enable = lib.mkEnableOption "Python and micromamba";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      python3
      micromamba
    ];

    # Session variables for Micromamba
    home.sessionVariables = {
      MAMBA_NO_LOW_SPEED_LIMIT = "1";
    };

    # Declarative Micromamba initialization
    programs.zsh.initContent = ''
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
}
