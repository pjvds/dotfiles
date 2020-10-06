#!/bin/zsh
if ! command -v hstr &> /dev/null
then
  warn "hstr missing!"
  return
fi

alias hh=hstr                         # hh to be alias for hstr
setopt histignorespace                # skip cmds w/ leading space from history
export HSTR_CONFIG=hicolor            # get more colors
bindkey -s "\C-r" "\C-a hstr -- \C-j" # bind hstr to Ctrl-r (for Vi mode check doc)
