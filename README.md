# dotfiles

This repostory contains 10 years of dotfile history with various configurations. Currently I'm running Arch Linux with the tilling window manager bspwm. Most applications are configured with a dark theme called monokai in combination with the purple tints of the dracula theme.

# Topical

These dotfiles follow the Low Coupling, High Cohesion principle. An example of this is that the hotkey daemon (sxhkd) doesn't know all the bindings of all applications. In other words, the hotkeys daemon configuration is not directly coupled to all applications that want a binding. Instead a application can express it's hotkey configuration in its own file (_topic_/hotkeys) that will be sources by the hotkey daemon.

# Modules
There's a few special files in the hierarchy.

* **bin/**: Anything in bin/ will get added to your $PATH and be made available everywhere.
* **_module_/login**: Executed then the windows manager is loaded.
* **_module_/init.zsh**: Sourced before any ZSH plugin or oh-my-zsh is loaded.
* **_module_/aliases.zsh**: Sourced after all ZSH plugins and oh-my-zsh is loaded.
* **_module_/hotkeys**: Sourced by the hotkey daemon sxhkd.
* **_module_/install.zsh**: Any file named install.sh is executed when you run script/install. This script should be idempotent.

# Features

## Blazing fast shell start time

``` zsh
$ time zsh -i -c exit
0.06s user 0.13s system 101% cpu 0.186 total
```

## Package list

After each login the current package list is saved to `arch/pkglist.txt` as a backup.

## Ly

A display manager (or login manager) that is displayed at the end of the boot process. It allows me to switch between different window managers like i3 and bspwm.

![display manager Ly](https://github.com/pjvds/dotfiles/raw/master/features/Ly-display-manager.png)

## Qutebrowser 

Press <kbd>Command</kbd> + <kbd>Q</kbd> to launch the qutebrowser profile picker. This allows you to pick a profile for the browser, comparable to Firefox Containers but at process level instead of tabs.

Profiles are identified by different border colors. Here is an example of 3 browser instances each running a different profile identified by a per profile border color.

![per profile border color](https://github.com/pjvds/dotfiles/raw/master/features/qutebrowser-profile-colors.png)

## bspwm

Tilling window manager that rocks!

## sxhkd

A simple X hotkey daemon that maps input events to command executions.

## polybar

A utility that is used to generate the status bar at the bottom of the screen.

![polybar](https://github.com/pjvds/dotfiles/raw/master/features/polybar.png)

## rofi

A utility to launch apps from the i3 desktop. [command]+[d] is bound to start it.

## qutebrowser

A keyboard-focused browser with a minimal GUI that allows you to surf the web without a mouse.

## alacritty

Fasted terminal emulator in the world.

## zsh

A modern shell most closely resembles Korn shell. Despite being over 20 years old it is considered _new_. Famous for command completion, path expansion and replacement. It is a Bash drop in replacement.

## oh-my-zsh

Turns the already great zsh shell into an 10x environment.

## z

Utility to jump to directies. It records all your directory changes and lets you jump to them. For example, `z code` will jump to `/home/pjvds/code`.

## vim

How to quit this editor?

## starship

A popular zsh prompt with async support. 

## ncspot

A commandline ncurses client for spotify. Think ncmpc but for the popular streaming service spotify.
&previous;

* Press <kbd>&laquo;</kbd> to skip to previous track
* Press <kbd>shift</kbd> + <kbd>&laquo;</kbd> to seek -10 seconds
* Press <kbd>&raquo;</kbd> to skip to next track
* Press <kbd>shift</kbd> + <kbd>&raquo;</kbd> to seek +10 seconds

## the silver searches

Searching tool with a focus on speed.

## reflex

Utility to watch file changes.

# AUR package maintainance

I'm maintaining a [few dozen AUR packages](https://aur.archlinux.org/packages/?K=pjvds&SeB=m) for Arch Linux. A daily CRON job runs on 
[github action](https://github.com/pjvds/dotfiles/actions/workflows/nvchecker.yml) to discover out dated packages.


I recently get questions on what tools I use to automate my workflow, so here is the list:

* `aurpublish` to install githooks for package repostory.
* `updpkgsums` to perform an in place update of the checksums.
* `nvchecker` to check for new versions ([config](https://github.com/pjvds/dotfiles/blob/master/nvchecker/nvchecker.toml)).
* `nvcmp` to compare version state files from nvchecker.
* `nvtake <pkg_name>` to accept the new version.

There is also a github action running that checks for new version everyday so I don't miss updates.

# Keyboard

My daily driver is a 40% ortholiniar keyboard that allows me to move keys towards my fingers, instead of moving my fingers to the keys. With this keyboard I never have to travel more than a single key in any direction.

## Specs

* Typeau .40 Planck Edition ([site](https://typeau.com/posts/typeau-40-planck-edition-update))
* OLKB Planck PCB Rev 6.1 ([site](https://olkb.com/products/planck-pcb))
* Matt3o /dev/tty keycaps with MT3 profile ([site](https://matt3o.com/about-mt3-profile-and-devtty-set/))
* Gateron Silent Clear (Linear | 4.0mm travel | 35g Actuation) ([site](https://candykeys.com/product/gateron-silent-clear))
* Krytox 205g0 lube for the switches and stabalizers
* TX switch films 0.125mm ([site](https://www.us.txkeyboards.com/products/switch-films?variant=32401591959612))
* ZealPC Stabilizers v2 ([site](https://zealpc.net/products/zealstabilizers))

## Keebsheet

Press <kbd>Command</kbd> + <kbd>Z</kbd> to toggle keebsheet.

![keyboard layout](https://github.com/pjvds/dotfiles/raw/master/qmk/keyboard-layout.png)
