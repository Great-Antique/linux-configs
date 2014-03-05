# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# save all history
PROMPT_COMMAND="history -n; history -a"

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

# show git branch
parse_git_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
 
  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
 
  echo " [$git_branch]"
}

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
        && type -P dircolors >/dev/null \
        && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
        # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
        if type -P dircolors >/dev/null ; then
                if [[ -f ~/.dir_colors ]] ; then
                        eval $(dircolors -b ~/.dir_colors)
                elif [[ -f /etc/DIR_COLORS ]] ; then
                        eval $(dircolors -b /etc/DIR_COLORS)
                fi
            fi

            if [[ $SSH_CLIENT == '' ]] ; then

                if [[ ${EUID} == 0 ]] ; then
                    PS1='${debian_chroot:+($debian_chroot)}\[\033[31m\]\u\[\033[32m\]$(parse_git_branch)\[\033[35m\] \w \[\033[00m\]\$ '
                else
                    PS1='${debian_chroot:+($debian_chroot)}\[\033[34m\]\u\[\033[32m\]$(parse_git_branch)\[\033[35m\] \w \[\033[00m\]\$ '
                fi

            else 

                if [[ ${EUID} == 0 ]] ; then
                    PS1='${debian_chroot:+($debian_chroot)}\[\033[31m\]work\[\033[32m\]$(parse_git_branch)\[\033[35m\] \w \[\033[00m\]\$ '
                else
                    PS1='${debian_chroot:+($debian_chroot)}\[\033[33m\]\u@work\[\033[32m\]$(parse_git_branch)\[\033[35m\] \w \[\033[00m\]\$ '
                fi
            fi

        alias ls='ls --color=auto'
        alias grep='grep --colour=auto'
else
        if [[ ${EUID} == 0 ]] ; then
                # show root@ when we don't have colors
                PS1='\u@\h \W \$ '
        else
                PS1='\u@\h \w \$ '
        fi
fi
