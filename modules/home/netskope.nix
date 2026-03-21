{ config, lib, ... }:
let
  netskopeCert   = "/Library/Application Support/Netskope/STAgent/data/nscacert.pem";
  homebrewBundle = "/opt/homebrew/etc/ca-certificates/cert.pem";
  combinedBundle = "${config.home.homeDirectory}/.cache/ca-bundle-combined.pem";
in {
  # Set CA bundle env vars for common CLI tools
  home.sessionVariables = {
    CURL_CA_BUNDLE      = combinedBundle;
    REQUESTS_CA_BUNDLE  = combinedBundle;  # Python requests, azure-cli
    SSL_CERT_FILE       = combinedBundle;  # Go, rustup, helm, general OpenSSL
    GIT_SSL_CAINFO      = combinedBundle;
    AWS_CA_BUNDLE       = combinedBundle;  # awscli2
    CLOUDSDK_CORE_CUSTOM_CA_CERTS_FILE = combinedBundle;  # gcloud / google-cloud-sdk
    # Node appends this on top of its built-in bundle, so single cert is fine
    NODE_EXTRA_CA_CERTS = netskopeCert;
    NODE_USE_SYSTEM_CA  = "1";
  };

  # Generate combined bundle (Homebrew CAs + Netskope CA) at activation time
  home.activation.netskopeCaBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ -f "${netskopeCert}" && -f "${homebrewBundle}" ]]; then
      mkdir -p "${config.home.homeDirectory}/.cache"
      cat "${homebrewBundle}" "${netskopeCert}" > "${combinedBundle}"
    fi
  '';
}
