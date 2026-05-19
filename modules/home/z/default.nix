{ config, lib, ... }:
let cfg = config.my.z; in
{
  options.my.z.enable = lib.mkEnableOption "zsh-z directory jumper";

  config = lib.mkIf cfg.enable {
    programs.zsh.shellAliases = {
      zl = "z -l";
      ze = "nvim ~/.z";
    };
  };
}
