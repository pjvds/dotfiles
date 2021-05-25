export NVM_LAZY_LOAD=true

# disable browser launch after npm/yarn start
export BROWSER=none

#source /usr/share/nvm/init-nvm.sh

# Placeholder 'nvm' shell function:
# Will only be executed on the first call to 'nvm'
nvm() {
  # Remove this function, subsequent calls will execute 'nvm' directly
  unfunction "$0"

  source /usr/share/nvm/init-nvm.sh

  # Execute binary
  $0 "$@"
}

npm() {
  # Remove this function, subsequent calls will execute 'nvm' directly
  unfunction "$0"

  source /usr/share/nvm/init-nvm.sh

  # Execute binary
  $0 "$@"
}
