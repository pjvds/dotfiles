# Placeholder 'nvm' shell function:
# Will only be executed on the first call to 'nvm'
nvm() {
  # Remove this function, subsequent calls will execute 'nvm' directly
  unfunction "$0"

  source /usr/share/nvm/init-nvm.sh

  # Execute binary
  $0 "$@"
}

