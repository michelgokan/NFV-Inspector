#!/bin/bash

NFV_MON_CLIENT_VERSION="1.0.0"

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

echo "Welcome to NFV-Inspector monitoring client installation wizard :-)"

if ! command_exists jq ; then
    echo 'jq and moreutils is not installed' >&2

    echo "Attempting to install jq and moreutils (only works on Ubuntu). May ask for sudo password."
    echo "sudo apt-get install jq moreutils"
    sudo apt-get install jq moreutils
fi

if [ -f ./config.json ]; then
    echo "A configuration already exists:"
    cat ./config.json
    echo "If you continue the installation it will overwrite above configuration. Are you sure you want to continue? (y/N): "
    read -r con
    if [ ! $con == 'y' ] && [ ! $con == 'Y' ]; then
       echo "Exiting installation"
       exit 0
    else
       rm ./config.json
       cat >./config.json <<EOF
{
    "general": {
        "name": "NFV_MON_CLIENT",
        "version": "$NFV_MON_CLIENT_VERSION",
        "server": { }
    }
}
EOF
    fi
fi

echo "Loading plugins:"

declare -a plugins
plugins_str=""
counter=1
cd Plugins
for f in */; do
  folder=${f%?}
  plugins[counter]="$folder"
  plugins_str="${plugins_str}${counter}=$folder, "
  echo "${plugins[$counter]}"
  counter=$[counter +1]

  cat ../config.json | jq -r ".plugins |= . + { \"$folder\": { } }" | sponge ../config.json

done

cd ..

echo $plugins_str
plugins_str=${plugins_str%??}
counter=$[counter -1]

echo "$counter plugins loaded!"

echo "Please select a CCMP (cloud computing management platform) integration plugin: ($plugins_str): "

read -r db

if ! array_element_exists db in plugins; then
    echo "Wrong choice"
    echo "Exiting installation wizard"
    exit 0
else
    cat config.json | jq -r ".general.ccmp = \"${plugins[$db]}\"" | sponge config.json
    echo "Running ./Plugins/${plugins[$db]}/config.sh"

    if [ ! -f ./Plugins/${plugins[$db]}/config.sh ]; then
        echo "NO_PLUGIN_CONFIG_ERROR: No config.sh file has been found in the plugin directory!" >&2
        exit 0
    else
        source ./Plugins/${plugins[$db]}/config.sh
    fi
fi

echo "Please enter NFV-MON server endpoint address: "
read -r nfv_mon_server_address

echo "Please enter NFV-MON server endpoint port: "
read -r nfv_mon_server_port

echo "Attempting to connect to NFV-MON server"

#TODO Add attempt to connect to NFV-MON Server

cat config.json | jq -r ".general.server = { \"address\": \"$nfv_mon_server_address\", \"port\": \"$nfv_mon_server_port\" }" | sponge config.json
