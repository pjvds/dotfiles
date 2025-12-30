# k8s zim module - Kubernetes tools with lazy-loaded completions
#
# This module provides kubectl, minikube, k3d, and argo with lazy-loaded
# shell completions. Completions are only sourced when you first use each tool,
# significantly improving shell startup time.

# Set up kubectl aliases
alias k="kubectl --namespace dev-namespace"
alias kd="kubectl --namespace dev-namespace"
alias kt="kubectl --namespace test-namespace"

# Note: The actual kubectl, minikube, k3d, argo, and kubeprintsec functions
# are in the functions/ directory and will be autoloaded by zim when first used.
# This provides lazy loading of expensive completion scripts.
