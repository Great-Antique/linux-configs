include(){

    baseDir='configs/'
    declare -a configsArray
    isRequired=0

    for arg in "$@" 
    do
        case $arg in
            -s)
                baseDir='.configs/'
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
        config=$baseDir$configName".bash"

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
    unset baseDir

}

include main system git grep mysql svn

include -s work
