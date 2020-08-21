# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions


# Color config for git-prompt
source ~/.colors

# if for some reason you want the whole path in the prompt 
# you can use these functions to toggle the prompt string options  

if [[ -z LONG_PROMPT ]] ; then
  LONG_PROMPT='true'
fi

function shorten_my_prompt {
  LONG_PROMPT='false'

}

function lengthen_my_prompt {
  LONG_PROMPT='true'
}

function color_my_prompt {
  set_virtualenv
  __user_and_host="$green\u@\h"
  if [[ $LONG_PROMPT == 'true' ]]; then
    __cur_location="$lightblue\w"               # small 'w': full file path
  else
    __cur_location="$lightblue\W"               # capital 'W': current directory,
  fi
  __git_branch_color="$green"
  __prompt_tail="$green$ "
  __user_input_color="$endcolorisation"
  # maybe toggle __git_branch for performance
  __git_branch='$(__git_ps1)';
  __virtual_env=$purple$PYTHON_VIRTUALENV


  # colour branch name depending on state
  if [[ "$(__git_ps1)" =~ "*" ]]; then     # if repository is dirty
      __git_branch_color="$redb"
  elif [[ "$(__git_ps1)" =~ "$" ]]; then   # if there is something stashed
      __git_branch_color="$yellow"
  elif [[ "$(__git_ps1)" =~ "%" ]]; then   # if there are only untracked files
      __git_branch_color="$white"
  elif [[ "$(__git_ps1)" =~ "+" ]]; then   # if there are staged files
      __git_branch_color="$lightblue"
  fi

  # Build the PS1 (Prompt String)
  PS1="$__user_and_host $__virtual_env$__cur_location$__git_branch_color$__git_branch $__prompt_tail$__user_input_color "
}

# configure PROMPT_COMMAND which is executed each time before PS1
export PROMPT_COMMAND=color_my_prompt

# if .git-prompt.sh exists, set options and execute it
if [ -f ~/.git-prompt.sh ]; then
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWUPSTREAM="auto"
  GIT_PS1_HIDE_IF_PWD_IGNORED=true
  GIT_PS1_SHOWCOLORHINTS=true
  . ~/.git-prompt.sh
fi

#   -----------------------------
#   some GIT stuff for the prompt: parse_git_branch and parse_git_dirty
#   -----------------------------

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
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

#   -----------------------------
#   Which Virtual Env am I using
#   -----------------------------
# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="[`basename \"$VIRTUAL_ENV\"`]"
  fi
}

#   -----------------------------
#   bash history options
#   -----------------------------

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# history settings
# Maximum numbers of lines that can be written to the file
export HISTFILESIZE=10000
# Change this to a reasonable number of lines to save
export HISTSIZE=10000
# Ignores duplicate lines next to each other and ignores a line with a leading space. (ignoredups and ignorespace combined)
export HISTCONTROL=ignoreboth
# Add timestapms to history entries
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

#   -----------------------------
#   Editor
#   -----------------------------

export EDITOR=vim

#   -----------------------------
#   TODO & Productivity
#   -----------------------------

#export TODO_DIR="$HOME/.todo"

#   -----------------------------
#   Alias
#   -----------------------------

alias prettyjson="python -m json.tool"
alias pyshell="pipenv shell"

#   -----------------------------
#   Functions
#   -----------------------------

function remoffkey() {
sed -i "$1d" ~/.ssh/known_hosts
}

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            #*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}
