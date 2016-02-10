# If not running interactively, don't do anything
[ -z "$PS1" ] && return

include(){

    baseDir=$(dirname ${BASH_SOURCE[0]})'/'
    configsDir=$baseDir'configs/'
    declare -a configsArray
    isRequired=0

    for arg in "$@" 
    do
        case $arg in
            -s)
                configsDir=$baseDir'.configs/'
                ;;
            -t)
                configsDir=$baseDir'themes/'
                ;;
            -r)
                isRequired=1
                ;;
            *)
                configsArray=("${configsArray[@]}" "$arg")
                ;;
        esac
    done

    for configName in "${configsArray[@]}"
    do
        config=$configsDir$configName".bash"

        if [[ -f $config ]]; then
            source $config
        else
            if [[ $isRequired == 1 ]]
            then
                echo "Required config $config doesn't exists"
                return 1;
            else
                echo "Config $config doesn't exists"
            fi
        fi
    done
    
    unset config    
    unset configName
    unset configsArray
    unset isRequired
    unset configsDir

}

if [[ -z $include ]]
then
    include main git grep mysql svn
else
    include $include
fi

if [[ -z $sinclude ]]
then
    include -s work
else
    include -s $sinclude
fi

if [[ -z $theme ]]
then
    include -t main
else
    include -t $theme
fi

### Attach screens on remote server

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    if [ -n $STY ]; then
        if  [ `screen -ls | grep 'Detached' | wc -l` -eq 1 ]; then
            screen -rd
        else
            echo "There are no or more than 1 detached screens"
        fi
    fi
fi
