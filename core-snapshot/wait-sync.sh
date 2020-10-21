#! /bin/sh

function is_syncing() {
    return "$(curl -s -G http://localhost:1317/syncing)" = '{"syncing":true}'
}

while [ is_syncing ]
do
    echo $(jobs -p)
    sleep 10;
done