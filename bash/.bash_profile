# .bash_profile

# Do this first since `command` won't work after 'vim' alias is setup
export EDITOR=vim
export GIT_EDITOR=vim
# If 'vim' doesn't exist, use vi
command -v vim >/dev/null 2>&1 || { export EDITOR=vi; }
command -v vim >/dev/null 2>&1 || { export GIT_EDITOR=vi; }

if [ -f ~/.bash_shell ]; then
	. ~/.bash_shell
fi

# User specific environment and startup programs

export XDG_CONFIG_HOME="$HOME/.config"

export BROWSER=firefox

export PATH=~/bin:$HOME/.local/bin:$PATH

# chromiumos depot_tools
PATH=$PATH:$HOME/Work/depot_tools

# rustup
source $HOME/.cargo/env

export PATH
