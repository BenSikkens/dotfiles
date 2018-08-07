# If not running interactively, don't do anything!
[[ $- != *i* ]] && return

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

#   -----------------------------
#   Colorised prompt with GIT stuff:
#   these functions use .git-prompt.sh which makes building the prompt a bit slow
#   -----------------------------

# Color config for git-prompt in separate file
source .colors

# creating the ability to switch between short and long path to pwd
# alias in the alias section of this file

if [[ -z LONG_PROMPT ]] ; then
  LONG_PROMPT='true'
fi

function shorten_my_prompt {
  LONG_PROMPT='false'
}

function lengthen_my_prompt {
  LONG_PROMPT='true'
}

# function for coloring the prompt

function color_my_prompt {
  __user_and_host="$GREEN\u@\h"
  if [[ $LONG_PROMPT == 'true' ]]; then
    __cur_location="$BLUE\w"               # small 'w': full file path
  else
    __cur_location="$BLUE\W"               # capital 'W': current directory,
  fi
  __git_branch_color="$GREEN"
  __prompt_tail="$PURPLE$ "
  __user_input_color="$ENDCOLORISATION"
  __git_branch='$(__git_ps1)';

  # colour branch name depending on state
  if [[ "$(__git_ps1)" =~ "*" ]]; then     # if repository is dirty
      __git_branch_color="$RED"
  elif [[ "$(__git_ps1)" =~ "$" ]]; then   # if there is something stashed
      __git_branch_color="$YELLOW"
  elif [[ "$(__git_ps1)" =~ "%" ]]; then   # if there are only untracked files
      __git_branch_color="$WHITE"
  elif [[ "$(__git_ps1)" =~ "+" ]]; then   # if there are staged files
      __git_branch_color="$LIGHTBLUE"
  fi

  # Build the PS1 (Prompt String)
  PS1="$__user_and_host $__cur_location$__git_branch_color$__git_branch $__prompt_tail$__user_input_color "
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
#   these functions provide an alternative for the Prompt String as used above
#   These are more lightweight but have no colorization
#   -----------------------------

# PS1="\u@\h:\w\`parse_git_branch\`\\$ "
# export PS1

# get current branch in git repo
#function parse_git_branch() {
#	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
#	if [ ! "${BRANCH}" == "" ]
#	then
#		STAT=`parse_git_dirty`
#		echo "[${BRANCH}${STAT}]"
#	else
#		echo ""
#	fi
#}

# get current status of git repo
#function parse_git_dirty {
#	status=`git status 2>&1 | tee`
#	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
#	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
#	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
#	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
#	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
#	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
#	bits=''
#	if [ "${renamed}" == "0" ]; then
#		bits=">${bits}"
#	fi
#	if [ "${ahead}" == "0" ]; then
#		bits="*${bits}"
#	fi
#	if [ "${newfile}" == "0" ]; then
#		bits="+${bits}"
#	fi
#	if [ "${untracked}" == "0" ]; then
#		bits="?${bits}"
#	fi
#	if [ "${deleted}" == "0" ]; then
#		bits="x${bits}"
#	fi
#	if [ "${dirty}" == "0" ]; then
#		bits="!${bits}"
#	fi
#	if [ ! "${bits}" == "" ]; then
#		echo " ${bits}"
#	else
#		echo ""
#	fi
#}

#   -----------------------------
#   Extract instead of other unpacking tools
#   -----------------------------

extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#   -----------------------------
#   tabCleaner:  remove tabs from file
#   -----------------------------

tabrem () {
  if [ -f $1 ] ; then
    cat "$1" | sed -E "s/[[:space:]]+/    /g"
  fi
}

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#   -----------------------------
#   some basic aliasses
#   -----------------------------

alias ll='ls -FGlAhp'
alias ls='ls -GFh'
alias path='echo -e ${PATH//:/\\n}'
alias smp='shorten_my_prompt'
alias lmp='lengthen_my_prompt'

#   -----------------------------
#   cleanupDS:  Recursively delete .DS_Store files
#   -----------------------------

alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   -----------------------------
#   super nice json pretty print
#   -----------------------------

alias prettyjson="python -m json.tool"

#   -----------------------------
#   WORK RELATED ALIASSES
#   -----------------------------
