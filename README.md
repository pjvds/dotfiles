# dotfiles

The base of my development environment is Fedora with the tilling window manager i3. Most applications are configured with a bright theme tomorrow.

## install

I've tried to automate the installation many times, but since I don't fully recreate my environment often it was outdated everytime I needed it. So, I ended up with a poors man solution to list all the installation commands with some comments. The commands are optimized for understandability rather than installation speed.

```
# install guest additions, first mount the disk [Devices->Insert Guest Additions CD Image...]
sudo dnf -y install gcc automake make kernel-headers kernel-devel perl
sudo /run/media/pjvds/VBOXADDITIONS*/VBoxLinuxAdditions.run

# install add user to virtualbox file system group, this enabled access to shared folders.
sudo usermod -aG vboxfs pjvds

# install i3 window manager
sudo dnf install -y i3 i3status dmenu conky

# install terminator
sudo dnf install -y terminator

# install vim
sudo dnf install -y vim-enhanced

# install spacevim
curl -sLf https://spacevim.org/install.sh | bash

# install zsh
sudo dnf install -y zsh

# change shell interactively, path: /usr/bin/zsh
sudo lchsh -i pjvds

# install sqlite
sudo dnf install -y sqlite

# install autojump
sudo dnf install -y autojump autojump-zsh

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install golang
sudo dnf install -y golang

# install node version manager n
curl -L https://git.io/n-install | bash

# install watchman
sudo dnf copr enable mkrawiec/watchman
sudo dnf install watchman

# install docker community edition
curl -fSL get.docker.com | bash
sudo usermod -aG docker pjvds
```

### i3

Tilling window manager that rocks!

### i3status

A utility that is used to generate the i3 status bar at the bottom of the screen.

### dmenu

A utility to launch apps from the i3 desktop. [command]+[d] is bound to start it.

### terminator

Terminal emulator with the styling support I need and extra features like the ability to follow links.

### zsh

A modern shell most closely resembles Korn shell. Despite being over 20 years old it is considered _new_. Famous for command completion, path expansion and replacement. It is a Bash drop in replacement and with `oh-my-zsh` is becomes 10x.

### sqlite

Self contained database. Used for multiple auto-complete scenario's in zsh, for example, completing dnf install arguments.

### autojump

Utility to jump to directies. It records all your directory changes and lets you jump to them. For example, `j evry` will jump to `/home/pjvds/Code/evry`.

### oh-my-zsh

Turns the already great zsh shell into an 10x environment.

### vim

How to quit this editor?

### spacevim

A popular community-driven vim distribution.

### watchman

Utility to watch file changes. This is used by many npm tasks in the node community.
