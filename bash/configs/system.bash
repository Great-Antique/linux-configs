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
