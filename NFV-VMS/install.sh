#!/bin/bash

NFV_VMS_VERSION="1.0.0"

source ../utils/functions.sh

echo "Welcome to NFV-Inspector VNFs Management Service installation wizard :-)"

if ! command_exists node ; then
    echo 'node/npm/jq is not installed' >&2

    echo "Attempting to install node, moreutils and jq (only works on Ubuntu). May ask for sudo password."
    echo "curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -"
    curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
    echo "sudo apt-get install -y nodejs moreutils jq"
    sudo apt-get install -y nodejs moreutils jq
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
       echo "Killing all running node processes..."
       sudo killall node
       sleep 2
       echo "Removing node_modules if exists..."
       rm -Rf ./node_modules
       echo "Installing modules..."
       npm install
       echo "Attempting to start API server..."
       node . &
       NODE_POD=$!
       showProgress
    fi
fi

echo "Loading plugins:"

declare -a plugins
plugins_str=""
counter=1
#cd Plugins
#for f in */; do
#  folder=${f%?}
#  plugins[counter]="$folder"
#  plugins_str="${plugins_str}${counter}=$folder, "
#  echo "${plugins[$counter]}"
#  counter=$[counter +1]
#done

cat package.json | jq ".officialPlugins" > t.json

while read -r line; do
  # Extract the value from between the double quotes
  # and add it to the array.
  [[ $line =~ :[[:blank:]]+\"(.*)\" ]] && plugins[counter]="${BASH_REMATCH[1]}" && plugins_str="${plugins_str}${counter}=${BASH_REMATCH[1]}, " && counter=$[counter +1]
done < t.json

rm -f t.json

#cd ..

echo $plugins_str
plugins_str=${plugins_str%??}
counter=$[counter -1]

echo "$counter plugins loaded!"

echo "Please select a CCMP (cloud computing management platform) integration plugin ($plugins_str): "

read -r ccmp

if ! array_element_exists ccmp in plugins; then
    echo "Wrong choice"
    echo "Exiting installation wizard"
    exit 0
else
    echo "Saving your choice..."

    curl -X POST --header 'Content-Type: application/json' --header \
     'Accept: application/json' -d \
     "{ \"category\": \"system\", \"key\": \"active_plugin\", \"value\": \"${plugins[$db]}\" }" \
     'http://127.0.0.1:3000/api/configurations'

    echo ''

    echo "Running ./node_modules/${plugins[ccmp]}/config.sh"

    if [ ! -f ./node_modules/${plugins[ccmp]}/config.sh ]; then
        echo "NO_PLUGIN_CONFIG_ERROR: No config.sh file has been found in the plugin directory or module not installed!" >&2
        exit 0
    else
        source ./node_modules/${plugins[ccmp]}/config.sh
    fi
fi

#echo "Please enter NFV-MON server endpoint address: "
#read -r nfv_mon_server_address
#
#echo "Please enter NFV-MON server endpoint port: "
#read -r nfv_mon_server_port
#
#echo "Attempting to connect to NFV-MON server"
#
##TODO Add attempt to connect to NFV-MON Server
#
#cat config.json | jq -r ".general.server = { \"address\": \"$nfv_mon_server_address\", \"port\": \"$nfv_mon_server_port\" }" | sponge config.json
