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

The [original article](https://martijnvos.dev/using-a-bare-git-repository-to-store-linux-dotfiles/) where I found these instructions.

If those instructions do not work, go through the initial setup instructions, then run:\
`dotfiles pull origin main`

The files from `vscode_config/` need to be manually copied into the location where vscode stores them. 

## About 

### Vscode

The keybindings are meant to be OS-agnostic since the only hotkey they use are CTRL and SHIFT. 
Many of them use a prefix system similar to tmux. 
