{ pkgs, ... }: {
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
  ];
}
