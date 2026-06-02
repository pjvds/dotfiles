{ config, lib, ... }:
let
  cfg = config.my.lmStudio;
in {
  options.my.lmStudio.enable = lib.mkEnableOption "LM Studio local LLM runner";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "lm-studio" ];
  };
}
