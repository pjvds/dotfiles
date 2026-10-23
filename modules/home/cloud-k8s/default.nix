{ config, pkgs, lib, ... }:
let
  cfg = config.my.cloudK8s;
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  # Fabric requires Invoke < 3: https://github.com/fabric/fabric/issues/2376
  azurePkgs = pkgs.extend (_: prev: {
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (_: pythonPrev: {
        # Redis integration tests stall on this macOS build; retain import checks.
        mocket = pythonPrev.mocket.overridePythonAttrs {
          doCheck = false;
        };
        invoke = pythonPrev.invoke.overridePythonAttrs {
          version = "2.2.1";
          src = prev.fetchPypi {
            pname = "invoke";
            version = "2.2.1";
            hash = "sha256-UVv0m0pIkyt5sCRZA0jaIvOcSULf+ZGtH7i4uuob5wc=";
          };
        };
      })
    ];
  });
in
{
  options.my.cloudK8s.enable = lib.mkEnableOption "cloud and Kubernetes tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      awscli2
      azurePkgs.azure-cli
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
