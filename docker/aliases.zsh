alias d='docker'
alias dfl='docker logs -f'
alias dc='docker-compose'
alias dcl='docker-compose logs -f'
alias dcu='docker-compose up -d'
alias dcfl='docker-compose logs -f'
alias dcps='docker-compose ps'

alias ctop='docker run \
  --rm -ti \
  --name=ctop \
  -v /var/run/docker.sock:/var/run/docker.sock \
  quay.io/vektorlab/ctop:latest'

# see: https://docs.docker.com/compose/completion/
alias lzd='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v /yourpath/config:/.config/jesseduffield/lazydocker lazyteam/lazydocker'

alias bcp='docker run -it --entrypoint /opt/mssql-tools/bin/bcp mcr.microsoft.com/mssql-tools'

alias asciicast2gif='docker run --rm -v $PWD:/data asciinema/asciicast2gif'

# print docker ip address for a container
function dip {
  docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
}
