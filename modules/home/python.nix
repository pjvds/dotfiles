{ pkgs, config, lib, ... }:
let cfg = config.my.python; in
{
  options.my.python.enable = lib.mkEnableOption "Python and pyenv";

  config = lib.mkIf cfg.enable {
    programs.pyenv.enable = true;

    home.packages = with pkgs; [
      python3
      (pipx.overrideAttrs (_: { doInstallCheck = false; }))
      pipenv
    ];

    programs.zsh = {
      shellAliases = {
        pip = "pip3";
      };
      initContent = ''
        # Pip user bin (pip install --user)
        export PATH="$PATH:$HOME/Library/Python/3.13/bin"

        # Pipx
        export PATH="$PATH:$HOME/.local/bin"

        # Defer pyenv initialization to speed up shell startup
        _init_pyenv() {
          eval "$(pyenv init -)"
        }
        zsh-defer _init_pyenv
      '';
    };
  };
}
