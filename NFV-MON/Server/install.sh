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
    fi
fi

rm ./config.json

echo "Please NFV-VMS endpoint address (i.e. 127.0.0.1): "
read -r NFV_VMS_ADDRESS

echo "Please NFV-VMS endpoint port (default port: 3000): "
read -r NFV_VMS_PORT

echo "Attempting to connect to NFV_VMS based on the given configuration: $NFV_VMS_ADDRESS:$NFV_VMS_PORT..."

status_code=$(curl --write-out %{http_code} --silent --output /dev/null "$NFV_VMS_ADDRESS:$NFV_VMS_PORT")

if [[ "$status_code" -eq 200 ]] ; then
  echo "NFV_VMS seems OK!"
  #cat config.json | jq -r ".general.server = { \"nfv_mon_server_address\": \"$nfv_mon_server_address\", \"nfv_mon_server_port\": \"$nfv_mon_server_port\", \"nfv_vms_address\": \"$NFV_VMS_ADDRESS\", \"nfv_vms_port\":\"$NFV_VMS_PORT\" }" | sponge config.json
else
  echo "Failed to connect to NFV_VMS!"
  echo "Exiting installation..."
  exit 0
fi

echo "Loading plugins:"

declare -a plugins
declare -a plugins_url
plugins_str=""
counter=1

cat package.json | jq ".officialPlugins" > t.json

while read -r line; do
  # Extract the value from between the double quotes
  # and add it to the array.
  [[ $line =~ [[:blank:]]*\"(.*)\"[[:blank:]]*:[[:blank:]]+\"(.*)\" ]] && plugins[counter]="${BASH_REMATCH[2]}" && plugins_url[counter]="${BASH_REMATCH[1]}" && plugins_str="${plugins_str}${counter}=${BASH_REMATCH[2]}, " && counter=$[counter +1]
done < t.json

rm -f t.json

plugins_str=${plugins_str%??}
echo $plugins_str
counter=$[counter -1]

echo "$counter plugins loaded!"

echo "Please select the time-series database backend plugin you want to use: ($plugins_str): "
read -r db

echo "Make sure no other instance of NFV-MON Server is running..."
#sudo killall node
sleep 2
echo "Removing node_modules if exists..."
rm -Rf ./node_modules
echo "Installing modules..."
npm install

selected_plugin_str=""

if ! array_element_exists db in plugins; then
  echo "Wrong choice[s]"
  echo "Exiting installation wizard"
  exit 0
fi

echo "Installing plugin ${plugins[db]}..."
echo "npm install ${plugins_url[db]}"
npm install ${plugins_url[db]}
selected_plugin_str="${selected_plugins_str}${plugins[db]}"

echo "Attempting to start API server on port 3002..."
node . &
showProgress

echo "Saving your choice..."

curl -X POST --header 'Content-Type: application/json' --header \
 'Accept: application/json' -d \
 "{ \"category\": \"system\", \"key\": \"active_plugin\", \"value\": \"$selected_plugin_str\" }" \
 'http://127.0.0.1:3002/api/configurations'

 curl -X POST --header 'Content-Type: application/json' --header \
 'Accept: application/json' -d \
 "{ \"category\": \"system\", \"key\": \"nfv_vms_server_address\", \"value\": \"$NFV_VMS_ADDRESS\" }" \
 'http://127.0.0.1:3002/api/configurations'

 curl -X POST --header 'Content-Type: application/json' --header \
 'Accept: application/json' -d \
 "{ \"category\": \"system\", \"key\": \"nfv_vms_server_port\", \"value\": \"$NFV_VMS_PORT\" }" \
 'http://127.0.0.1:3002/api/configurations'

echo ''

echo "Attempt running ./node_modules/${plugins[db]}/config.sh"
source ./node_modules/${plugins[db]}/config.sh

if [ ! -f ./node_modules/${plugins[db]}/config.sh ]; then
  echo "NO_PLUGIN_CONFIG_ERROR: No config.sh file has been found in the plugin directory or module not installed!" >&2
  exit 0
fi

echo "*****"
echo "Installation Successful!"
echo "Please visit http://127.0.0.1:3002/explorer to access NFV-MON Swagger API documentation"
