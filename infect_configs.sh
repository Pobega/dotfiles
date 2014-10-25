#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IGNORE=(
    'infect_configs.sh'
	'README.md'
)

function infect {
    if [[ ! -f ~/.$1 ]]; then
        ln -s "$DIR/$1" ~/.$1
    fi
}

function containsElement () {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

for file in $(ls); do
    if ! containsElement $file ${IGNORE[@]}; then
        infect $file
    fi
done
