unalias z

# enhance z jump with pwd print
z() {
  _z $@ && tput setaf 3; echo $(pwd); tput sgr0
}
