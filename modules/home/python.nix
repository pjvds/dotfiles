{ pkgs, config, lib, ... }:
let cfg = config.my.python; in
{
  options.my.python.enable = lib.mkEnableOption "Python and pyenv";

  config = lib.mkIf cfg.enable {
    programs.pyenv = {
      enable = true;
      # home-manager's own zsh integration runs `eval "$(pyenv init - zsh)"`
      # synchronously in initContent, which forks the pyenv binary and
      # re-does its shim rehash on every shell startup (~200ms measured).
      # We already defer the equivalent init below via zsh-defer, so the
      # built-in synchronous integration would just duplicate that cost.
      enableZshIntegration = false;
    };

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

        # PYENV_ROOT must be set before pyenv is used (deferred below), but
        # the export itself is cheap (no fork), so it doesn't need deferring.
        export PYENV_ROOT="${config.programs.pyenv.rootDirectory}"

        # Defer pyenv initialization to speed up shell startup
        _init_pyenv() {
          eval "$(pyenv init - zsh)"
        }
        zsh-defer _init_pyenv
      '';
    };
  };
}
