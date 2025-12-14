# dotfiles
Random configuration files I use. Clone this repository and symlink these into your home directory.

## Usage
Use GNU stow to symlink these files to your own home directory.

## bash
The bash configuration is similar to ohmyzsh, except more portable. Git status is printed to the right of the prompt and has coloring for the current HEAD state.

![bashrc screenshot](https://raw.githubusercontent.com/pobega/dotfiles/master/bash.png)

## git
Nothing special, just sets up git-sendmail for sending patches to kernel mailing lists. Also includes a basic global gitignore file.

## mutt
Optimized for interfacing with the kernel mailing list. Automatically decrypts an encrypted password file at runtime.

## nvim
Neovim configuration using AstroNvim with various plugins for enhanced editing experience.

## quadlets
Podman quadlets for containerless server applications. [Upstream documentation](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html).

## tmux
Lots of workflow changes here. Backtick used as the meta command for ease of use. Read the configuration file if you want more information.

![tmux screenshot](https://raw.githubusercontent.com/pobega/dotfiles/master/tmux.png)

## vim
Does a few neat things like add a nice crosshair, highlights empty spacing and a bunch of other stuff.

Also utilizes git submodules and the Vim 8 plugin system to autoload helpful plugins (and gruvbox colorscheme) at start.

It's well commented, so again, read the file.

![vim4 screenshot](https://raw.githubusercontent.com/pobega/dotfiles/master/vim.png)
