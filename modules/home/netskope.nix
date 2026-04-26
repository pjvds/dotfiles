{ config, lib, ... }:
let
  cfg = config.my.netskope;
  netskopeCert   = "/Library/Application Support/Netskope/STAgent/data/nscacert.pem";
  homebrewBundle = "/opt/homebrew/etc/ca-certificates/cert.pem";
  combinedBundle = "${config.home.homeDirectory}/.cache/ca-bundle-combined.pem";
in
{
  options.my.netskope.enable = lib.mkEnableOption "Netskope CA bundle integration";

  config = lib.mkIf cfg.enable {
    # Set CA bundle env vars only when the combined bundle actually exists.
    # home.sessionVariables is static (build-time), so we use initExtra instead
    # to guard the exports at runtime — preventing broken SSL when Netskope is absent.
    programs.zsh.initExtra = ''
      if [[ -f "${combinedBundle}" ]]; then
        export CURL_CA_BUNDLE="${combinedBundle}"
        export REQUESTS_CA_BUNDLE="${combinedBundle}"  # Python requests, azure-cli
        export SSL_CERT_FILE="${combinedBundle}"       # Go, rustup, helm, general OpenSSL
        export GIT_SSL_CAINFO="${combinedBundle}"
        export AWS_CA_BUNDLE="${combinedBundle}"       # awscli2
        export CLOUDSDK_CORE_CUSTOM_CA_CERTS_FILE="${combinedBundle}"  # gcloud / google-cloud-sdk
        # Node appends this on top of its built-in bundle, so single cert is fine
        export NODE_EXTRA_CA_CERTS="${netskopeCert}"
        export NODE_USE_SYSTEM_CA="1"
      fi
    '';

    # Generate combined bundle (Homebrew CAs + Netskope CA) at activation time.
    # Only runs when Netskope is installed; no bundle means no SSL env vars are set.
    home.activation.netskopeCaBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [[ -f "${netskopeCert}" && -f "${homebrewBundle}" ]]; then
        mkdir -p "${config.home.homeDirectory}/.cache"
        cat "${homebrewBundle}" "${netskopeCert}" > "${combinedBundle}"
      fi
    '';
  };
}
