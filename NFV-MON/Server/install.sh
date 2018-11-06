#!/bin/bash

NFV_MON_SERVER_VERSION="1.0.0"

source ../../utils/functions.sh

echo "Welcome to NFV-Inspector monitoring server installation wizard :-)"

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

       echo "Please NFV-VMS endpoint address: "

       read -r NFV_VMS_ADDRESS

       echo "Please NFV-VMS endpoint point: "

       read -r NFV_VMS_PORT

       cat >./config.json <<EOF
{
    "general": {
        "name": "NFV_MON_SERVER",
        "version": "$NFV_MON_SERVER_VERSION",
        "nfv_vms_address": "$NFV_VMS_ADDRESS",
        "nfv_vms_port": "$NFV_VMS_PORT"
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

echo "Please select the time-series database backend plugin you want to use: ($plugins_str): "

read -r db

if ! array_element_exists db in plugins; then
    echo "Wrong choice"
    echo "Exiting installation wizard"
    exit 0
else
    cat config.json | jq -r ".general.backend_db = \"${plugins[$db]}\"" | sponge config.json
    echo "Running ./Plugins/${plugins[$db]}/config.sh"

    if [ ! -f ./Plugins/${plugins[$db]}/config.sh ]; then
        echo "NO_PLUGIN_CONFIG_ERROR: No config.sh file has been found in the plugin directory!"
    else
        source ./Plugins/${plugins[$db]}/config.sh
    fi
fi

cd src

echo "Enabling REST API Server"
npm install

node .