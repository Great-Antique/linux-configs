# show git branch
parse_git_branch() {
    local dirty
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    return 0
  fi

  dirty=''
  [[ -n $(git status -s 2> /dev/null | tail -n 1) ]] && dirty="*"
 
  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
 
  echo " [$git_branch$dirty]"
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

else
        if [[ ${EUID} == 0 ]] ; then
                # show root@ when we don't have colors
                PS1='\u@\h \W \$ '
        else
                PS1='\u@\h \w \$ '
        fi
fi
