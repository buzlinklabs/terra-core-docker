#! /bin/sh

is_syncing() {
    echo "$(curl -s -G http://localhost:1317/syncing)" = '{"syncing":true}'
}

timestamp() {
    echo $(date +%s)
}

last_commit_time=$(timestamp)

check_sync() {
    if [ $(( $last_commit_time + 10 )) -lt $(timestamp) ]
    then
        if [ ! $(is_syncing) ]
        then
            exit 0
        fi
    fi
}

height=""

while read line
do
    height="$(echo $line | sed -n 's/^.*Committed.*height=\([[:digit:]]\+\).*$/\1/p')"

    if [ -z "$height" ]
    then
        $(check_sync)
    else
        last_commit_time=$(timestamp)
        echo "synced $height"

        if [ $# -lt 1 ] || [ $1 -lt 1 ]
        then
            $(check_sync)
            continue
        fi

        if [ $height -gt $1 ]
        then
            echo "Reach limit ($1/$height)"
            exit 0
        fi
    fi
done