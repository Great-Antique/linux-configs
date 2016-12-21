# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# save all history
# SAVEHISTORY='history -n; history -a; ';
SAVEHISTORY='history -a; ';

if [[ $shortPwdInTitle == 1 ]]
then
    getShortPwd(){
        if [[ $PWD == $HOME ]]; then
            SHORT_PWD='~'
        else
            if [[ `echo $PWD | grep -o $HOME | wc -l` -eq 1 ]]; then
                SHORT_PWD="~/.../"`echo ${PWD/${HOME}/\~} | awk '{gsub(/\/$/, ""); print}' | awk -F '/' '{print $NF }'`
            else
                SHORT_PWD=".../"`echo $PWD | awk '{gsub(/\/$/, ""); print}' | awk -F '/' '{print $NF }'`
            fi
        fi
        echo $SHORT_PWD
    }
    PROMPT_COMMAND=$SAVEHISTORY'SHORT_PWD=`getShortPwd`; echo -ne "\033]0; ${USER}@${HOSTNAME} : $SHORT_PWD\007"'
else
    PROMPT_COMMAND=$SAVEHISTORY'echo -ne "\033]0; ${USER}@${HOSTNAME} \007"'
fi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
# HISTFILESIZE=2000
unset HISTFILESIZE

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

### system

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

uax(){
    ps uax | grep "$*";
}

in_array() {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

# aliases
alias cl="clear"
alias ll='ls -alF'
alias lll='ll | less'
alias la='ls -A'
alias l='ls -CF'
alias llg='ll | grep '

#alias duh='du -h --max-depth=1'
alias duh='ls -a | grep -v "^\.\.$" | grep -v "^\.$" | xargs du -sch'

alias upgrade='aptitude update && aptitude safe-upgrade'

# bash completion
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# disable touchpad
if [[ $toggleTouchpad == 0 ]]
then
    declare -i touchPadId
    touchPadId=`xinput list | grep -Eo 'TouchPad\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
    declare -i touchPadState
    touchPadState=`xinput list-props $touchPadId | grep 'Device Enabled' | awk '{print $4}'`
    if [ $touchPadState -eq 1 ]
    then
        xinput disable $touchPadId
        echo "Touchpad disabled."
    fi
fi

if [[ $toggleTouchpad == 1 ]]
then
    declare -i touchPadId
    touchPadId=`xinput list | grep -Eo 'TouchPad\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
    declare -i touchPadState
    touchPadState=`xinput list-props $touchPadId | grep 'Device Enabled' | awk '{print $4}'`
    if [ $touchPadState -eq 0 ]
    then
        xinput enable $touchPadId
        echo "Touchpad enabled."
    fi
fi

function searchinbrowser {
    xdg-open `getsearchurl "$@"`
}

alias '?'='searchinbrowser'
