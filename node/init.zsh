export NVM_LAZY_LOAD=true

# disable browser launch after npm/yarn start
export BROWSER=none

alias vitest='npx vitest'
alias sst='npx sst'

if [[ `uname` == "Darwin" ]]; then
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
else
  zinit ice wait"1" lucid
  zinit load /usr/share/nvm
fi
