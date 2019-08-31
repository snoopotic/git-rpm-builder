#!/bin/bash
set -x

if [ ! "${GITVERSION}" ]; then
    export GITVERSION=$(curl --silent "https://api.github.com/repos/git/git/tags" | jq -r '.[0].name' | cut -d v -f 2);
fi

GITVERSION=${GITVERSION} docker run --rm uploadimage 
