# Darwin-side install for the Home Manager cloud-k8s module (HM cannot set homebrew.*).
{ config, lib, ... }:
let
  hm = config.home-manager.users.${config.system.primaryUser};
in {
  config = lib.mkIf hm.my.cloudK8s.enable {
    # Prebuilt cask; nixpkgs builds its Python dependency tree from source
    homebrew.casks = lib.mkAfter [ "azure-cli" ];
  };
}
