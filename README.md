# dotfiles
Random configuration files I use. Clone this repository and symlink these into your home directory.

## Usage
Use GNU stow to symlink these files to your own home directory.

## bash
The bash configuration is similar to ohmyzsh, except more portable. It shows the runtime of the last command and git status information.

![bashrc screenshot](https://raw.githubusercontent.com/pobega/dotfiles/master/bash.png)

## fish
An alternative shell choice.

![fish screenshot](https://raw.githubusercontent.com/pobega/dotfiles/master/fish.png)

## git
Nothing special, just sets up git-sendmail for sending patches to kernel mailing lists.

## mutt
Optimized for interfacing with the kernel mailing list. Automatically decrypts an encrypted password file at runtime.

## tmux
Lots of workflow changes here. Just read the configuration file if you want more information.

![tmux screenshot](https://raw.githubusercontent.com/pobega/dotfiles/master/tmux.png)

## vim
Setup to run a few plugins at start if they exist (vim is smart enough to not complain plugins are missing, so you can ignore them), adds a nice crosshair, and a bunch of other stuff. It's well commented, so again, read the file.

![vim4 screenshot](https://raw.githubusercontent.com/pobega/dotfiles/master/vim.png)
