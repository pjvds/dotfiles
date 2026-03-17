{ pkgs, config, lib, ... }: {
  home.packages = with pkgs; [
    python3
    conda
  ];

  # Session variables for Conda
  home.sessionVariables = {
    CONDA_AUTO_ACTIVATE_BASE = "false";
  };

  # Declarative Conda initialization
  programs.zsh.initContent = ''
    # Enable Conda shell hook if installed
    if [ -f "${config.home.homeDirectory}/miniconda3/etc/profile.d/conda.sh" ]; then
      source "${config.home.homeDirectory}/miniconda3/etc/profile.d/conda.sh"
    fi
  '';
}
