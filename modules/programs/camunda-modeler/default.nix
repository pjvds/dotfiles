{ config, lib, ... }:
let
  cfg = config.my.camundaModeler;
in {
  options.my.camundaModeler.enable =
    lib.mkEnableOption "Camunda Desktop Modeler";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "camunda-modeler" ];
  };
}
