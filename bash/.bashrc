#
# ~/.bashrc
#

# xterm transparency
[ -n "$XTERM_VERSION" ] && transset-df -a 0.95 >/dev/null

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME
