vercomp() {
    if [[ $1 == $2 ]]; then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i = 0; i < ${#ver1[@]}; i++)); do
        if ((10#${ver1[i]:=0} > 10#${ver2[i]:=0})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done
    return 0
}

testvercomp() {
    vercomp $1 $2
    case $? in
        0) op='=' ;;
        1) op='>' ;;
        2) op='<' ;;
    esac
    if [[ $op != $3 ]]; then
        # No update available
        echo "1"
    else
        # Update available
        echo "0"
    fi
}
