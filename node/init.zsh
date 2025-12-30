# node zim module - Node.js environment with lazy-loaded fnm
#
# This module sets up the Node.js environment with fnm (Fast Node Manager).
# fnm initialization is lazy-loaded to improve shell startup time.

# Disable browser launch after npm/yarn start
export BROWSER=none

# Convenient aliases for common tools
alias vitest='pnpx vitest'
alias sst='pnpx sst'

# Load nvm bash completion if available (macOS with homebrew)
if [[ "$OSTYPE" == "darwin"* ]]; then
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# Note: The fnm function is in the functions/ directory and will be
# autoloaded by zim when first used. This provides lazy loading of
# fnm environment initialization.
#
# To use fnm immediately (load on cd), you'll need to run: fnm env --use-on-cd
# Or just use fnm once and it will initialize automatically.
