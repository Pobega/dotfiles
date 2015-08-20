#
# ~/.bashrc
#

source ~/.bash_aliases

# xterm transparency
#[ -n "$XTERM_VERSION" ] && transset-df -a 0.89 >/dev/null

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME

# Automatic X login on TTY1
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# rtv editor
export RTV_EDITOR=vim

export BROWSER=google-chrome-stable
export EDITOR=vim

# Makes fonts darker and thicker
export INFINALITY_FT_BRIGHTNESS="-10"

# Not too sharp, not too smooth
export INFINALITY_FT_FILTER_PARAMS="16 20 28 20 16"

export PATH=~/bin:$PATH

eval $(dircolors ~/.dircolors)

