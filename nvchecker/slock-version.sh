#!/bin/zsh
cd $(mktemp -d)
git clone --depth 1 git://git.suckless.org/slock .
echo $(git log -1 --format='%cd.%h' --date=short | tr -d -)
