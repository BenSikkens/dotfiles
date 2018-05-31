# export PS1="___________________    | \w @ \h (\u) \n| => "
# export PS2="| => "

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

alias ll='ls -FGlAhp'
alias ls='ls -GFh'
alias path='echo -e ${PATH//:/\\n}'

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
#   cleanupDS:  Recursively delete .DS_Store files
#   -----------------------------

alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   -----------------------------
#   super nice json pretty print
#   -----------------------------

alias prettyjson="python -m json.tool"


#   -----------------------------
#   WORK RELATED STUFF
#   -----------------------------
