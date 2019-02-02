#!/bin/bash

NFV_VMS_VERSION="1.0.0"

source ../utils/functions.sh

echo "Welcome to NFV-Inspector VNFs Management Service installation wizard :-)"

if ! $(command_exists mysql && command_exists node && command_exists jq); then
    echo 'node/npm/jq/mysql-client is not installed' >&2

    echo "Attempting to install node, moreutils, mysql-client and jq (only works on Ubuntu). May ask for sudo password."
    echo "curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -"
    curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
    sudo apt update && apt dist-upgrade
    echo "sudo apt-get install -y nodejs moreutils jq mysql-client"
    sudo apt-get install -y nodejs moreutils jq mysql-client
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

echo "Please enter MySQL server address (i.e 127.0.0.1): "
read -r mysql_address

echo "Please enter MySQL server port (i.e 3306): "
read -r mysql_port

echo "Please enter MySQL server username (i.e root): "
read -r mysql_username

echo "Please enter MySQL server password : "
read -r mysql_password

echo "Checking MySQL server connection with given credentials..."

if mysql -h $mysql_address -P $mysql_port -u $mysql_username -p$mysql_password -e ";" ; then
  echo "A successful MySQL connection was made with the parameters defined for this connection."
else
  echo "MySQL connection failed..."
  echo "Exiting installation"
  exit 0
fi

echo "Please enter MySQL server database (i.e NFV_VMS): "
read -r mysql_database

echo "[Re]create MySQL scheme? (y/N) : "
read -r mysql_database_recreate

if [ ! $mysql_database_recreate == 'y' ] && [ ! $mysql_database_recreate == 'Y' ]; then
  if mysql -h $mysql_address -P $mysql_port -u $mysql_username -p$mysql_password -D $mysql_database -e ";" ; then
    echo "Database OK!"
  else
    echo "mysql -h $mysql_address -P $mysql_port -u $mysql_username -p$mysql_password -D $mysql_database -e \";\""
    echo "Database is not there!"
    echo "Exiting installation"
    exit 0
  fi
else
  echo "[Re]creating MySQL scheme..."
  if mysql -h $mysql_address -P $mysql_port -u $mysql_username -p$mysql_password \
    -e "DROP DATABASE IF EXISTS $mysql_database; CREATE DATABASE $mysql_database;"; then
    echo "Database successfully created!"
  else
    echo "Error creating database!"
    echo "Exiting installation"
    exit 0
  fi
fi

echo "Add MySQL as datasource..."
echo "{}" | jq ".mysql = { \"host\": \"$mysql_address\", \"port\": $mysql_port, \"url\": \"mysql://$mysql_username:$mysql_password@$mysql_address:$mysql_port/$mysql_database\", \"database\": \"$mysql_database\", \"password\": \"$mysql_password\", \"name\": \"mysql\", \"user\": \"$mysql_username\", \"connector\": \"mysql\" }" | jq ".db = {\"name\": \"db\", \"connector\": \"memory\", \"file\": \"config.json\" }" | sponge ./server/datasources.json
rm ./config.json

echo "Loading plugins:"

declare -a plugins
declare -a plugins_url
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
  [[ $line =~ [[:blank:]]*\"(.*)\"[[:blank:]]*:[[:blank:]]+\"(.*)\" ]] && plugins[counter]="${BASH_REMATCH[2]}" && plugins_url[counter]="${BASH_REMATCH[1]}" && plugins_str="${plugins_str}${counter}=${BASH_REMATCH[2]}, " && counter=$[counter +1]
done < t.json

rm -f t.json

#cd ..

plugins_str=${plugins_str%??}
echo $plugins_str
counter=$[counter -1]

echo "$counter plugins loaded!"

echo "Please enter a comma seperated list of integration plugins to install ($plugins_str): "
read -r list_of_ccmps

echo "Make sure no other instance of NFV-VMS is running..."
#sudo killall node
sleep 2
echo "Removing node_modules if exists..."
rm -Rf ./node_modules
echo "Installing modules..."
npm install

selected_plugins_str=""


for ccmp in $(echo $list_of_ccmps | sed "s/,/ /g")
do
    if ! array_element_exists ccmp in plugins; then
      echo "Wrong choice[s]"
      echo "Exiting installation wizard"
      exit 0
    fi

    echo "Installing plugin ${plugins[ccmp]}..."
    echo "npm install ${plugins_url[ccmp]}"
    npm install ${plugins_url[ccmp]}
    selected_plugins_str="${selected_plugins_str}${plugins[ccmp]},"
done
selected_plugins_str=${selected_plugins_str%?}

echo "Attempting to start API server on port 3000..."
node . &
showProgress

echo "Saving your choice..."

curl -X POST --header 'Content-Type: application/json' --header \
 'Accept: application/json' -d \
 "{ \"category\": \"system\", \"key\": \"active_plugins\", \"value\": \"$selected_plugins_str\" }" \
 'http://127.0.0.1:3000/api/configurations'

 curl -X POST --header 'Content-Type: application/json' --header \
 'Accept: application/json' -d \
 "{ \"category\": \"system\", \"key\": \"mysql_address\", \"value\": \"$mysql_address\" }" \
 'http://127.0.0.1:3000/api/configurations'

 curl -X POST --header 'Content-Type: application/json' --header \
 'Accept: application/json' -d \
 "{ \"category\": \"system\", \"key\": \"mysql_port\", \"value\": \"$mysql_port\" }" \
 'http://127.0.0.1:3000/api/configurations'

 curl -X POST --header 'Content-Type: application/json' --header \
 'Accept: application/json' -d \
 "{ \"category\": \"system\", \"key\": \"mysql_username\", \"value\": \"$mysql_username\" }" \
 'http://127.0.0.1:3000/api/configurations'

 curl -X POST --header 'Content-Type: application/json' --header \
 'Accept: application/json' -d \
 "{ \"category\": \"system\", \"key\": \"mysql_password\", \"value\": \"$mysql_password\" }" \
 'http://127.0.0.1:3000/api/configurations'

 curl -X POST --header 'Content-Type: application/json' --header \
 'Accept: application/json' -d \
 "{ \"category\": \"system\", \"key\": \"mysql_database\", \"value\": \"$mysql_database\" }" \
 'http://127.0.0.1:3000/api/configurations'

echo ''

for ccmp in $(echo $list_of_ccmps | sed "s/,/ /g")
do
  echo "Attempt running ./node_modules/${plugins[ccmp]}/config.sh"
  source ./node_modules/${plugins[ccmp]}/config.sh

  if [ ! -f ./node_modules/${plugins[ccmp]}/config.sh ]; then
    echo "NO_PLUGIN_CONFIG_ERROR: No config.sh file has been found in the plugin directory or module not installed!" >&2
    exit 0
  fi
done

echo "*****"
echo "Installation Successful!"
echo "Please visit http://127.0.0.1:3000/explorer to access Swagger API documentation"
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
