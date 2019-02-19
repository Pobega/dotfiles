# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -f ~/.bash_shell ]; then
	. ~/.bash_shell
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/Work/depot_tools

export PATH
