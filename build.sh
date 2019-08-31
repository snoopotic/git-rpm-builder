#!/bin/bash

if [ ! "${GITVERSION}" ]; then
    export GITVERSION=$(curl --silent "https://api.github.com/repos/git/git/tags" | jq -r '.[0].name' | cut -d v -f 2);
fi

docker build --build-arg GITVERSION=${GITVERSION} -t uploadimage .