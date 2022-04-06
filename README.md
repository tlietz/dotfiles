# Dotfiles

## Initial Setup

Initially, I setup this repo by doing:
```terminal
mkdir ~/.dotfiles

git init --bare ~/.dotfiles

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

dotfiles config status.showUntrackedFiles no

dotfiles remote add origin https://github.com/tlietz/dotfiles.git
```


## Importing to another machine

1. `git clone --separate-git-dir=~/.dotfiles https://github.com/tlietz/dotfiles.git ~`
2. `alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'` if the standard `.config` file for the host terminal is not already setup in the dotfiles directory. 


## About 

### Vscode

The keybindings are meant to be OS-agnostic since the only hotkey they use are CTRL and SHIFT. 
Many of them use a prefix system similar to tmux. 
