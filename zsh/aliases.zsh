alias qq='exit'
alias :q='exit'

# Use colors for ls and grep
if [[ -z ${NO_COLOR} ]]; then
  export CLICOLOR=1
  export LSCOLORS="ExfxcxdxbxGxDxabagacad"
  alias grep='grep --color=auto'
fi
