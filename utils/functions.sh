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

