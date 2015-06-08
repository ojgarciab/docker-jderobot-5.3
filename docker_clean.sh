#! /bin/bash

while read -r image
do
    echo "Removing partial image $image"
    CONTAINER=$(docker ps | grep "[^a-f0-9]caed7f3a228b" | cut -d " " -f 1)
    if [ -n "$CONTAINER" ]
    then
        echo " > Stopping running container $CONTAINER"
        docker stop "$CONTAINER"
    fi
    CONTAINER=$(docker ps -a | grep "[^a-f0-9]caed7f3a228b" | cut -d " " -f 1)
    if [ -n "$CONTAINER" ]
    then
        echo " > Removing container $CONTAINER"
        docker rm "$CONTAINER"
    fi
    echo " > Removing image $image"
    docker rmi "$image"
done < <(docker images | grep "^<none>" | sed 's/ \+/ /g' | cut -d " " -f 3)

