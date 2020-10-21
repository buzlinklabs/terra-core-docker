#! /bin/sh

is_syncing() {
    echo "$(curl -s -G http://localhost:1317/syncing)" = '{"syncing":true}'
}

timestamp() {
    echo $(date +%s)
}

last_commit_time=0

finish() {
    kill -SIGINT $(ps -e | grep "terrad start" | grep -v grep | awk '{print $1}')
    kill -SIGINT $(ps -e | grep "terracli" | grep -v grep | awk '{print $1}')
    exit 0
}

check_sync() {
    if [ $(( $last_commit_time + 10 )) -lt $(timestamp) ]
    then
        if [ ! $(is_syncing) ]
        then
            finish
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
        echo "synced $height/$1"

        if [ $# -lt 1 ] || [ $1 -lt 1 ]
        then
            $(check_sync)
            continue
        fi

        if [ $height -ge $1 ]
        then
            echo "Reach target height : $height"
            finish
        fi
    fi
done