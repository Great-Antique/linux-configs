### git
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
# conflicts with go lang
# alias go='git checkout '

alias theirs="grep -lr  -color=none '<<<<<<<' . | xargs git checkout --theirs"
