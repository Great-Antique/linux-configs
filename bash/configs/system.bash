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

alias duh='du -h --max-depth=1'

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
if [[ $disableTouchpad == 1 ]]
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

