unalias z

# enhance z jump with pwd print
z() {
  _z $@ && tput setaf 3; echo $(pwd); tput sgr0
}

alias zl="z -l"
alias ze="vim ~/.z"
