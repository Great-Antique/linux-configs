### grep

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
alias grep="grep --color=always"

# alias rgrep="grep --line-number --color=always --recursive --exclude-dir='.svn'"
xgrep(){
    grep --line-number --color=always --recursive --exclude-dir='.svn' --exclude='tags' "$*" *;
}
