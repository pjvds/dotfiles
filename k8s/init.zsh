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

    # Execute binary
    $0 "$@"
  }
fi


# Check if 'argo' is a command in $PATH
if [ $commands[argo] ]; then

  # Placeholder 'argo' shell function:
  # Will only be executed on the first call to 'argo'
  argo() {
    # Remove this function, subsequent calls will execute 'kubectl' directly
    unfunction "$0"

    eval $(argo completion zsh)

    # Execute binary
    $0 "$@"
  }
fi
