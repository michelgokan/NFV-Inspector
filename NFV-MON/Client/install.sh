#!/bin/bash

NFV_MON_CLIENT_VERSION="1.0.0"

source ../../utils/functions.sh

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

echo "Please enter NFV-MON server endpoint address (i.e 127.0.0.1): "
read -r nfv_mon_server_address

echo "Please enter NFV-MON server endpoint port (default: 8080): "
read -r nfv_mon_server_port

echo "Attempting to connect to NFV-MON server"

NFV_MON_RESPONSE=$(curl $nfv_mon_server_address:$nfv_mon_server_port/ping)
if [ $NFV_MON_RESPONSE == 'pong' ]; then
    echo "NFV_MON seems OK!"
else
    echo "Failed to connect to NFV_MON"
    echo $NFV_MON_RESPONSE
    echo "Exiting installation!"
    exit 0
fi

echo "Getting NFV-MON server configuration at $nfv_mon_server_address:$nfv_mon_server_port..."
NFV_MON_CONFIG=$(curl $nfv_mon_server_address:$nfv_mon_server_port)

echo $NFV_MON_CONFIG

NFV_VMS_ADDRESS=$(echo $NFV_MON_CONFIG | jq --raw-output '.general.nfv_vms_address')
NFV_VMS_PORT=$(echo $NFV_MON_CONFIG | jq --raw-output '.general.nfv_vms_port')

echo "Attempting to connect to NFV_VMS based on the retrieved configuration: $NFV_VMS_ADDRESS:$NFV_VMS_PORT..."

status_code=$(curl --write-out %{http_code} --silent --output /dev/null "$NFV_VMS_ADDRESS:$NFV_VMS_PORT")

if [[ "$status_code" -eq 200 ]] ; then
  echo "NFV_VMS seems OK!"
  echo "Saving configs..."
  cat config.json | jq -r ".general.server = { \"nfv_mon_server_address\": \"$nfv_mon_server_address\", \"nfv_mon_server_port\": \"$nfv_mon_server_port\", \"nfv_vms_address\":\"$NFV_VMS_ADDRESS\", \"nfv_vms_port\":\"$NFV_VMS_PORT\" }" | sponge config.json
else
  echo "Failed to connect to NFV_VMS!"
  echo "Exiting installation..."
  exit 0
fi

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

echo "Installation successful!"

#cat config.json | jq -r ".general.server = { \"address\": \"$nfv_mon_server_address\", \"port\": \"$nfv_mon_server_port\" }" | sponge config.json
