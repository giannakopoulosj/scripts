

Everything is local

All variable should be local.

change_owner_of_file() {
    local filename=$1
    local user=$2
    local group=$3

    chown $user:$group $filename
}

change_owner_of_files() {
    local user=$1; shift
    local group=$1; shift
    local files=$@
    local i

    for i in $files
    do
        chown $user:$group $i
    done
}
