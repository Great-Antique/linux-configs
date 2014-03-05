### svn

xdiff(){
    svn diff $*;
}

xup(){
    svn up $*;
}

xst(){
    svn st $* | less;
}

xrevert(){
    svn revert $*;
}

xci(){
    output="" # output string
    declare -a paramArr=("$@") # get input params and store it as array
    count=${#paramArr[@]} # calculate count of array's elements
    n=0 # initialize loop's count
    while [ $n -lt $count ]; # loop the array
    do
        sc=$(echo ${paramArr[$n]} | grep -o " " | wc -l)
        if [ $sc -gt 0 ]; then # first param must be in double quotes
            output=$output" \""${paramArr[$n]}"\""
        else # other params
            output=$output" "${paramArr[$n]}
        fi
        let n=$n+1 # increase loop's count
    done
    eval "svn ci -m $output";
}
