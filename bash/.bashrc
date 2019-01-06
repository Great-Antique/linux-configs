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
            # else
            #     echo "Config $config doesn't exists"
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
    include main git grep mysql svn locale z
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
        fi
    fi
fi


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
# set PATH so it includes linux-configs bin if it exists
baseDir=$(dirname ${BASH_SOURCE[0]})'/'
binDir=$baseDir'bin'
if [ -d $binDir ] ; then
    PATH="$binDir:$PATH"
fi
# add composer bin to PATH
if [ -d "$HOME/.composer/vendor/bin" ] ; then
    PATH="$HOME/.composer/vendor/bin:$PATH"
fi
# add composer alter bin to PATH
if [ -d "$HOME/.config/composer/vendor/bin" ] ; then
    PATH="$HOME/.config/composer/vendor/bin:$PATH"
fi

# Symfony autocomplete
type symfony-autocomplete >> /dev/null 2>&1
if [ $? -eq 0 ]; then
    eval "$(symfony-autocomplete --aliases spress --aliases robo --aliases phpunit)"
fi
