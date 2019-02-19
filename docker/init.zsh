alias d='docker'
alias dc='docker-compose'
alias dcl='docker-compose logs -f'
alias dcu='docker-compose up -d'
alias dcfl'docker-compose logs -f'

alias ctop='docker run --rm -ti \
  --name=ctop \
  -v /var/run/docker.sock:/var/run/docker.sock \
  quay.io/vektorlab/ctop:latest'
