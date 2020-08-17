# dotfiles
Random configuration files I use. Clone this repository and symlink these into your home directory.

## Usage
Use GNU stow to symlink these files to your own home directory.

## bash
The bash configuration is similar to ohmyzsh, except more portable. Git status is printed to the right of the prompt and has coloring for the current HEAD state.

![bashrc screenshot](https://raw.githubusercontent.com/pobega/dotfiles/master/bash.png)

## fish
An alternative shell choice. Slightly cleaner UI than my bash config with similar functionality.

![fish screenshot](https://raw.githubusercontent.com/pobega/dotfiles/master/fish.png)

## tmux
Lots of workflow changes here. Backtick used as the meta command for ease of use. Read the configuration file if you want more information.

![tmux screenshot](https://raw.githubusercontent.com/pobega/dotfiles/master/tmux.png)

## vim
Does a few neat things like add a nice crosshair, highlights empty spacing and a bunch of other stuff.

Also utilizes git submodules and the Vim 8 plugin system to autoload helpful plugins (and gruvbox colorscheme) at start.

It's well commented, so again, read the file.

![vim4 screenshot](https://raw.githubusercontent.com/pobega/dotfiles/master/vim.png)

## git
Nothing special, just sets up git-sendmail for sending patches to kernel mailing lists.

## mutt
Optimized for interfacing with the kernel mailing list. Automatically decrypts an encrypted password file at runtime.

## ublock
Shared ublock configuration with medium mode on and a few useful things whitelisted.

## steam-controller
uinput stuff for using the Steam Controller on Linux. Includes a modprobe file for autoloading the uinput module at boot (required for systemd permissions)
