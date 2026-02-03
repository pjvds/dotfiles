export PATH="$fortify_bin:$PATH"
alias fcli='docker run --platform=linux/amd64 --rm -v "${HOME}:${HOME}" -v "${PWD}:${PWD}" -e "FCLI_USER_HOME=${HOME}" -e "FCLI_DEFAULT_SSC_URL=https://ssc.aat.deloitte.com/ssc" -w "${PWD}" -u $(id -u):$(id -g) fortifydocker/fcli'
