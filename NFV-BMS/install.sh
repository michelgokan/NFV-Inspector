#!/bin/bash

NFV_BMS_VERSION="1.0.0"

my_dir="$(dirname "$0")"

source "$my_dir/../utils/functions.sh"

echo "Welcome to NFV-Inspector Benchmarking Management Service installation wizard :-)"

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
#       cat >./config.json <<EOF
#{
#    "general": {
#        "name": "NFV_BMS",
#        "version": "$NFV_BMS_VERSION",
#        "server": { }
#    }
#}
#EOF

echo "Please enter NFV-MON server endpoint address (i.e. 127.0.0.1): "
read -r nfv_mon_server_address

echo "Please enter NFV-MON server endpoint port (default port: 3002): "
read -r nfv_mon_server_port

echo "Attempting to connect to NFV-MON server"

NFV_MON_RESPONSE=$(curl $nfv_mon_server_address:$nfv_mon_server_port/ping)
if [ $NFV_MON_RESPONSE == 'pong' ]; then
    echo "NFV-MON server seems OK!"
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
  #cat config.json | jq -r ".general.server = { \"nfv_mon_server_address\": \"$nfv_mon_server_address\", \"nfv_mon_server_port\": \"$nfv_mon_server_port\", \"nfv_vms_address\": \"$NFV_VMS_ADDRESS\", \"nfv_vms_port\":\"$NFV_VMS_PORT\" }" | sponge config.json
else
  echo "Failed to connect to NFV_VMS!"
  echo "Exiting installation..."
  exit 0
fi

echo "Retrieving MySQL configuration from NFV-VMS..."

MYSQL_ADDRESS=$(curl -X GET --header 'Accept: application/json' "http://$NFV_VMS_ADDRESS:$NFV_VMS_PORT/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22mysql_address%22%7D%7D" | jq --raw-output '.value')
MYSQL_PORT=$(curl -X GET --header 'Accept: application/json' "http://$NFV_VMS_ADDRESS:$NFV_VMS_PORT/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22mysql_port%22%7D%7D" | jq --raw-output '.value')
MYSQL_USERNAME=$(curl -X GET --header 'Accept: application/json' "http://$NFV_VMS_ADDRESS:$NFV_VMS_PORT/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22mysql_username%22%7D%7D" | jq --raw-output '.value')
MYSQL_PASSWORD=$(curl -X GET --header 'Accept: application/json' "http://$NFV_VMS_ADDRESS:$NFV_VMS_PORT/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22mysql_password%22%7D%7D" | jq --raw-output '.value')
MYSQL_DATABASE="NFV_BMS"

echo "Add MySQL as datasource..."
echo "{}" | jq ".mysql = { \"host\": \"$MYSQL_ADDRESS\", \"port\": $MYSQL_PORT, \"url\": \"mysql://$MYSQL_USERNAME:$MYSQL_PASSWORD@$MYSQL_ADDRESS:$MYSQL_PORT/$MYSQL_DATABASE\", \"database\": \"$MYSQL_DATABASE\", \"password\": \"$MYSQL_PASSWORD\", \"name\": \"mysql\", \"user\": \"$MYSQL_USERNAME\", \"connector\": \"mysql\" }" | jq ".db = {\"name\": \"db\", \"connector\": \"memory\", \"file\": \"config.json\" }" | sponge ./server/datasources.json

echo "[Re]create MySQL scheme? (y/N) : "
read -r mysql_database_recreate

if [ ! $mysql_database_recreate == 'y' ] && [ ! $mysql_database_recreate == 'Y' ]; then
  if ! mysql -h $MYSQL_ADDRESS -P $MYSQL_PORT -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -D $MYSQL_DATABASE -e ";" ; then
    echo "Database OK!"
  else
    echo "Database is not there!"
    echo "Exiting installation"
    exit 0
  fi
else
  echo "[Re]creating MySQL scheme..."
  if mysql -h $MYSQL_ADDRESS -P $MYSQL_PORT -u $MYSQL_USERNAME -p$MYSQL_PASSWORD \
    -e "DROP DATABASE IF EXISTS $MYSQL_DATABASE; CREATE DATABASE $MYSQL_DATABASE;"; then
    echo "Database successfully created!"
  else
    echo "Error creating database!"
    echo "Exiting installation"
    exit 0
  fi
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

echo $plugins_str
plugins_str=${plugins_str%??}
counter=$[counter -1]

echo "$counter plugins loaded!"

echo "Please enter a benchmarking integration plugin to install and load ($plugins_str): "
read -r plugin

echo "Make sure no other instance of NFV-VMS is running..."
#sudo killall node
sleep 2
echo "Removing node_modules if exists..."
rm -Rf ./node_modules
echo "Installing modules..."
npm install


if ! array_element_exists plugin in plugins; then
  echo "Wrong choice[s]"
  echo "Exiting installation wizard"
  exit 0
fi

echo "Installing plugin ${plugins[plugin]}..."
echo "npm install ${plugins_url[plugin]}"
npm install ${plugins_url[plugin]}

echo "Checking if ./node_modules/${plugins[plugin]}/config.sh exists..."

if [ ! -f ./node_modules/${plugins[plugin]}/config.sh ]; then
    echo "NO_PLUGIN_CONFIG_ERROR: No config.sh file has been found in ./node_modules/${plugins[plugin]}/ or module not installed!" >&2
    echo "Exiting installation!"
    exit 0
fi

echo "Running NFV-BMS..."
echo "Starting NFV-BMS on port 3001"
node . &
showProgressLonger

  echo "Saving configs..."

  curl -X POST --header "Content-Type: application/json" --header \
 "Accept: application/json" -d \
 "{ \"category\": \"system\", \"key\": \"nfv_mon_server_address\", \"value\": \"$nfv_mon_server_address\" }" \
 "http://127.0.0.1:3001/api/configurations"

 curl -X POST --header "Content-Type: application/json" --header \
 "Accept: application/json" -d \
 "{ \"category\": \"system\", \"key\": \"nfv_mon_server_port\", \"value\": \"$nfv_mon_server_port\" }" \
 "http://127.0.0.1:3001/api/configurations"

 curl -X POST --header "Content-Type: application/json" --header \
 "Accept: application/json" -d \
 "{ \"category\": \"system\", \"key\": \"nfv_vms_address\", \"value\": \"$NFV_VMS_ADDRESS\" }" \
 "http://127.0.0.1:3001/api/configurations"

 curl -X POST --header "Content-Type: application/json" --header \
 "Accept: application/json" -d \
 "{ \"category\": \"system\", \"key\": \"nfv_vms_port\", \"value\": \"$NFV_VMS_PORT\" }" \
 "http://127.0.0.1:3001/api/configurations"

echo "Attempting to run ./node_modules/${plugins[plugin]}/config.sh"
source ./node_modules/${plugins[plugin]}/config.sh

echo ""
echo "Installation successful!"
#cat config.json | jq -r ".general.server = { \"address\": \"$nfv_mon_server_address\", \"port\": \"$nfv_mon_server_port\" }" | sponge config.json

