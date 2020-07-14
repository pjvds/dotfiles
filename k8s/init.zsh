alias k="kubectl --namespace dev-namespace"
alias kd="kubectl --namespace dev-namespace"
alias kt="kubectl --namespace test-namespace"

# Check if 'k3d' is a command in $PATH
if [ $commands[k3d] ]; then

  # Placeholder 'k3d' shell function:
  # Will only be executed on the first call to 'k3d'
  k3d() {
    # Remove this function, subsequent calls will execute 'kubectl' directly
    unfunction "$0"

    # Load auto-completion
    eval $(k3d completion zsh)

    # Execute 'kubectl' binary
    $0 "$@"
  }
fi
