# Dotfiles

## Importing config

```terminal
mv .tmux.conf .tmux.conf.old

mv .bashrc .bashrc.old

mkdir ~/.dotfiles

git init --bare ~/.dotfiles

git branch -M main

git checkout main

alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

dotfiles config status.showUntrackedFiles no

dotfiles remote add origin https://github.com/tlietz/dotfiles.git

dotfiles pull origin main
```

## About 
The [original article](https://martijnvos.dev/using-a-bare-git-repository-to-store-linux-dotfiles/) where I found these instructions.
