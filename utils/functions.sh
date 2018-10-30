#!/bin/bash

command_exists () {
   type "$1" &> /dev/null ;
}

array_element_exists(){
  if [ "$2" != in ]; then
    echo "Incorrect usage."
    echo "Correct usage: exists {key} in {array}"
    return
  fi
  eval '[ ${'$3'[$1]+muahaha} ]'
}

esc_var() {
    local ESCAPED_QUOTES=$(echo "$1" | sed 's|"|\\"|g')
    printf '%s' "${ESCAPED_QUOTES}"
}

if ! command_exists jq ; then
    echo 'jq and moreutils is not installed' >&2

    echo "Attempting to install jq and moreutils (only works on Ubuntu). May ask for sudo password."
    echo "sudo apt-get install jq moreutils"
    sudo apt-get install jq moreutils
fi

showProgress () {
    echo -ne '###                       (20%)\r'
    sleep 1
    echo -ne '#########                 (40%)\r'
    sleep 1
    echo -ne '#############             (60%)\r'
    sleep 1
    echo -ne '###################       (80%)\r'
    sleep 1
    echo -ne '#######################   (100%)\r'
    sleep 1
}