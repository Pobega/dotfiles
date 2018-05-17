#
# ~/.bashrc
#

[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# Local bashrc for contextual settings (work, home, etc)
[[ -f ~/.bashrc_local ]] && . ~/.bashrc_local

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

function print_256_colors {
  for i in {0..255} ; do
    printf "\x1b[38;5;${i}m%3d " "${i}"
    if (( $i == 15 )) || (( $i > 15 )) && (( ($i-15) % 12 == 0 )); then
        echo;
    fi
   done
}

export XDG_CONFIG_HOME="$HOME/.config"

export BROWSER=firefox
export EDITOR=vim
export TERM=xterm-256color

export PATH=~/bin:$HOME/.local/bin:$PATH

# get current branch in git repo
function parse_git_branch() {
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ! "${BRANCH}" == "" ]; then
    STAT=`parse_git_dirty`
    if [ ! "${STAT}" == "" ]; then
      echo -e "\001\e[48;5;88m\002\001\e[38;5;254m\002 ${BRANCH}${STAT} \001\e[0m\002\001\e[38;5;88m\002"
    else
      echo -e "\001\e[48;5;28m\002\001\e[38;5;254m\002 ${BRANCH} \001\e[0m\002\001\e[38;5;28m\002"
    fi
  else
    echo -e "\001\e[0m\002\001\e[38;5;238m\002\001\e[0m\002"
  fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# Unix epoch time in nanoseconds
function epoch_ms {
  date +%s%3N
}

# Record our start time
function timer_start {
  start_time=${start_time:-$(epoch_ms)}
}

function timer_stop {
  local ms=$(($(epoch_ms) - $start_time))
  local s=$(((ms / 1000) % 60))
  local m=$(((ms / 60000) % 60))
  local h=$((ms / 3600000))
  if ((h > 0)); then timer_show=${h}h${m}m
  elif ((m > 0)); then timer_show=${m}m${s}s
  elif ((s > 9)); then local us=$(((${ms} % 1000)/ 100)); timer_show=${s}.$(printf $us)s
  elif ((s > 0)); then local us=$((${ms} % 1000)); timer_show=${s}.$(printf %03d $us)s
  else timer_show=${ms}ms
  fi
  unset start_time
}

function get_cwd {
  if [ "${PWD}" == "${HOME}" ]; then
    echo "~"
  else
    if [ "${PWD}" == "/" ]; then
      echo "/"
    else
      directory="${PWD%/*}"
      echo "${directory##*/}/${PWD##*/}/"
    fi
  fi
}

trap 'timer_start' DEBUG
PROMPT_COMMAND=timer_stop

## Different color for different users
# Home should be blue, work should be purple, other should be orange
# root should always be red
MAIN_COLOR=202
if [ "${HOSTNAME}" == "hotbox" ]; then
  MAIN_COLOR=92
else
  if [ "${HOSTNAME}" == "merlin" ]; then
    MAIN_COLOR=26
  fi
fi
if [ "${USER}" == "root" ]; then
  MAIN_COLOR=88
fi

## TODO: make a proper/pretty non-256 color version of prompt
#if [[ "$TERM" =~ 256color ]]; then
PS1='\[\e[38;5;254;48;5;${MAIN_COLOR}m\] \u \[\e[38;5;${MAIN_COLOR};48;5;236m\]\[\e[38;5;254m\] $(get_cwd) \[\e[38;5;236;48;5;238m\]\[\e[38;5;254m\] ${timer_show} \[\e[38;5;238m\]$(parse_git_branch)\[\e[0m\] '
#else
#  PS1='[\u:$(get_cwd)]$(parse_git_branch)[${timer_show}]$ '
#fi
