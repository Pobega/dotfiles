#
# ~/.bashrc
#

source ~/.bash_aliases

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME

export BROWSER=google-chrome-stable
export EDITOR=vim
export TERM=xterm

export PATH=~/bin:$PATH

function epoch_ms {
  date +%s%3N
}

function timer_start {
  start_time=${start_time:-$(epoch_ms)}
}

function timer_stop {
  timer_show=$(($(epoch_ms) - $start_time))
  unset start_time
}

trap 'timer_start' DEBUG
PROMPT_COMMAND=timer_stop

PS1='[\u:\w][${timer_show}ms]$ '
