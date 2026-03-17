# k8s zim module - Kubernetes tools with lazy-loaded completions
#
# This module provides kubectl, minikube, k3d, and argo with lazy-loaded
# completions and aliases.

# Set up kubectl aliases
alias k="kubectl --namespace dev-namespace"
alias kd="kubectl --namespace dev-namespace"
alias kt="kubectl --namespace test-namespace"

# Add functions to fpath and autoload them
fpath=(${0:h}/functions $fpath)
autoload -U argo k3d kubectl kubeprintsec minikube
# are in the functions/ directory and will be autoloaded by zim when first used.
# This provides lazy loading of expensive completion scripts.
