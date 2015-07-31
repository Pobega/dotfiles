#
# ~/.bashrc
#

source ~/.bash_aliases

# xterm transparency
[ -n "$XTERM_VERSION" ] && transset-df -a 0.90 >/dev/null

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME

# Automatic X login on TTY1
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
