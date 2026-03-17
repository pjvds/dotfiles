{ pkgs, config, lib, ... }: {
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
    # Enable Micromamba shell hook
    if command -v micromamba &>/dev/null; then
      export MAMBA_ROOT_PREFIX="$HOME/.micromamba"
      eval "$(micromamba shell hook --shell zsh)"
    fi
  '';
}
