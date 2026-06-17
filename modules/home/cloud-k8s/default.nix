{ config, pkgs, lib, ... }:
let
  cfg = config.my.cloudK8s;
  dotfiles = "${config.home.homeDirectory}/dotfiles";
in
{
  options.my.cloudK8s.enable = lib.mkEnableOption "cloud and Kubernetes tools";

  config = lib.mkIf cfg.enable {
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
      # pulumi installed via Homebrew (brew install pulumi/tap/pulumi)
      # — nixpkgs does not include the .NET language plugin required for this project
    ];

    home.file.".config/k9s/skin.yml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/state/theme/k9s-skin.yml";

    programs.zsh = {
      shellAliases = {
        k  = "kubectl --namespace dev-namespace";
        kd = "kubectl --namespace dev-namespace";
        kt = "kubectl --namespace test-namespace";
      };
      initContent = ''
        # Lazy-load kubectl, k3d, argo, minikube completions on first use
        fpath=(${dotfiles}/modules/home/cloud-k8s/config/functions $fpath)
        autoload -U argo k3d kubectl kubeprintsec minikube
      '';
    };
  };
}
