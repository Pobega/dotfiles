# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -f ~/.bash_shell ]; then
	. ~/.bash_shell
fi

# User specific environment and startup programs

export XDG_CONFIG_HOME="$HOME/.config"

export BROWSER=firefox
export EDITOR=vim

export PATH=~/bin:$HOME/.local/bin:$PATH

# chromiumos depot_tools
PATH=$PATH:$HOME/Work/depot_tools

# rustup
source $HOME/.cargo/env

export PATH
