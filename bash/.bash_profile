# .bash_profile

# Do this first since `command` won't work after 'vim' alias is setup
export EDITOR=vim
export GIT_EDITOR=vim
# If 'vim' doesn't exist, use vi
command -v vim >/dev/null 2>&1 || { export EDITOR=vi; }
command -v vim >/dev/null 2>&1 || { export GIT_EDITOR=vi; }

[[ -f ~/.bash_shell ]] && . ~/.bash_shell
[[ -f ~/.bash_path ]] && . ~/.bash_path
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -f ~/.bashrc_local ]] && . ~/.bashrc_local
[[ -f ~/.bash_work ]] && . ~/.bash_work

# User specific environment and startup programs

export XDG_CONFIG_HOME="$HOME/.config"

export BROWSER=firefox

# local bins
#export PATH=~/bin:$HOME/.local/bin:$PATH

# chromiumos depot_tools
#export PATH=$HOME/Work/depot_tools:$PATH

# rustup
[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

#export PATH
