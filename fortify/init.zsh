#local fortify_bin="$HOME/Applications/Fortify/Fortify_Apps_and_Tools_24.4.0/bin"
local fortify_bin="$HOME/Applications/Fortify/Fortify_SCA_24.4.1/bin"
if [ ! -d "$fortify_bin" ]; then
  warn "Fortify not found at $fortify_bin"
fi

export PATH="$fortify_bin:$PATH"
alias fcli='docker run --platform=linux/amd64 --rm -v "${HOME}:${HOME}" -v "${PWD}:${PWD}" -e "FCLI_USER_HOME=${HOME}" -e "FCLI_DEFAULT_SSC_URL=https://ssc.aat.deloitte.com/ssc" -w "${PWD}" -u $(id -u):$(id -g) fortifydocker/fcli'
