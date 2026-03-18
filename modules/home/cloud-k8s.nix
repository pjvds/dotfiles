{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    awscli2
    azure-cli
    google-cloud-sdk
    kubectl
    kubectx
    k9s
    kubernetes-helm
    k3d
    argo-workflows
    kubelogin
  ];

  home.file = {
    ".config/k9s/skin.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/k8s/k9s-skin.yml";
  };
}
