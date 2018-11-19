#!/bin/bash

echo "Please enter your required monitoring interval (i.e 1 means 1 second):"
read -r monitoring_interval

echo "Please enter your log level (0,1,2 or 3):"
read -r monitoring_log_level

echo "Monitoring enabled by default? (0=No, 1=Yes):"
read -r monitoring_enabled

echo "Retrieving NFV-MON configuration from $nfv_mon_server_address:$nfv_mon_server_port..."
ACTIVE_BACKEND_DB_PLUGIN_NAME=$(curl -X GET --header 'Accept: application/json' "http://$nfv_mon_server_address:$nfv_mon_server_port/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22active_plugin%22%7D%7D" | jq --raw-output '.value')

#TODO: HARD-CODED IF: We should change this part!
if [ $ACTIVE_BACKEND_DB_PLUGIN_NAME == 'nfv-inspector-mon-influxdb-plugin' ]; then
    echo "InfluxDB is supported!"
    BACKEND_DB_HOST=$(curl -X GET --header 'Accept: application/json' "http://$nfv_mon_server_address:$nfv_mon_server_port/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22influxdb_host%22%7D%7D" | jq --raw-output '.value')
    BACKEND_DB_PORT=$(curl -X GET --header 'Accept: application/json' "http://$nfv_mon_server_address:$nfv_mon_server_port/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22influxdb_port%22%7D%7D" | jq --raw-output '.value')
    BACKEND_DB_USERNAME=$(curl -X GET --header 'Accept: application/json' "http://$nfv_mon_server_address:$nfv_mon_server_port/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22influxdb_username%22%7D%7D" | jq --raw-output '.value')
    BACKEND_DB_PASSWORD=$(curl -X GET --header 'Accept: application/json' "http://$nfv_mon_server_address:$nfv_mon_server_port/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22influxdb_password%22%7D%7D" | jq --raw-output '.value')
    BACKEND_DB_DATABASE=$(curl -X GET --header 'Accept: application/json' "http://$nfv_mon_server_address:$nfv_mon_server_port/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22influxdb_database%22%7D%7D" | jq --raw-output '.value')

    echo "IMPORTANT QUESTION: May break the system later on if answered incorrectly!"
    echo "Are you sure you already have a database with name \"$BACKEND_DB_DATABASE\" in your InfluxDB server at $BACKEND_DB_HOST? (y/n):"
    read -r backend_database_exists

    #TODO: Add Automated checking
    if [ ! $backend_database_exists == 'y' ] && [ ! $backend_database_exists == 'Y' ]; then
        echo "Database is not there!"
        echo "Exiting installation"
        exit 0
    fi
else
    echo "No compatible adaptor exists for the $ACTIVE_BACKEND_DB_PLUGIN_NAME database!"
    echo "Consider add a compatible adaptor in adapters folder"
    echo "Exiting installation!"
    exit 0
fi

echo "Retrieved information from NFV-MON server..."
echo -e "Backend database type: $ACTIVE_BACKEND_DB_PLUGIN_NAME \nBackend database address: $BACKEND_DB_HOST \nBackend database port: $BACKEND_DB_PORT \nBackend database username: $BACKEND_DB_USERNAME\nBackend database password: $BACKEND_DB_PASSWORD\n"

echo "Retrieving Kubernetes information from NFV-VMS on $NFV_VMS_ADDRESS:$NFV_VMS_PORT..."
KUBERNETES_ADDRESS=$(curl -X GET --header 'Accept: application/json' "http://$NFV_VMS_ADDRESS:$NFV_VMS_PORT/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22kubernetes_api_address%22%7D%7D" | jq --raw-output '.value')
KUBERNETES_PORT=$(curl -X GET --header 'Accept: application/json' "http://$NFV_VMS_ADDRESS:$NFV_VMS_PORT/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22kubernetes_api_port%22%7D%7D" | jq --raw-output '.value')
KUBERNETES_TOKEN=$(curl -X GET --header 'Accept: application/json' "http://$NFV_VMS_ADDRESS:$NFV_VMS_PORT/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22kubernetes_token%22%7D%7D" | jq --raw-output '.value')
KUBERNETES_API_PROTOCOL=$(curl -X GET --header 'Accept: application/json' "http://$NFV_VMS_ADDRESS:$NFV_VMS_PORT/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22kubernetes_api_protocol%22%7D%7D" | jq --raw-output '.value')

echo "kubernetes_address=$KUBERNETES_ADDRESS\nkubernetes_port=$KUBERNETES_PORT\nkubernetes_token=$KUBERNETES_TOKEN"

echo "Cloning Kubernetes Open Monitoring (kube-openmon) platform"

rm -Rf kube-openmon
git clone https://github.com/michelgokan/kube-openmon

cd kube-openmon

echo "Configuring kube-openmon..."

sed -i -e "s/{MONITORING_INTERVAL}/$monitoring_interval/g" ./kube-openmon.yaml
sed -i -e "s/{LOG_LEVEL}/$monitoring_log_level/g" ./kube-openmon.yaml
sed -i -e "s/{ENABLED}/$monitoring_enabled/g" ./kube-openmon.yaml

#TODO: Hard-coded!!!! Consider changing this part!
if [ $ACTIVE_BACKEND_DB_PLUGIN_NAME == 'InfluxDB' ]; then
    sed -i -e "s/{INFLUXDB_ADDRESS}/$BACKEND_DB_HOST/g" ./kube-openmon.yaml
    sed -i -e "s/{INFLUXDB_PORT}/$BACKEND_DB_PORT/g" ./kube-openmon.yaml
    sed -i -e "s/{INFLUXDB_USERNAME}/$BACKEND_DB_USERNAME/g" ./kube-openmon.yaml
    sed -i -e "s/{INFLUXDB_PASSWORD}/$BACKEND_DB_PASSWORD/g" ./kube-openmon.yaml
    sed -i -e "s/{INFLUXDB_DATABASE}/$BACKEND_DB_DATABASE/g" ./kube-openmon.yaml
fi

sed -i -e "s/{KUBERNETES_CUSTOM_ADDRESS}/$KUBERNETES_ADDRESS/g" ./kube-openmon.yaml
sed -i -e "s/{KUBERNETES_CUSTOM_PORT}/$KUBERNETES_PORT/g" ./kube-openmon.yaml
sed -i -e "s/{KUBERNETES_CUSTOM_TOKEN}/$KUBERNETES_TOKEN/g" ./kube-openmon.yaml

echo "kube-openmon configuration..."
cat ./kube-openmon.yaml

echo "Current location:"
pwd
echo "Sourcing functions.sh"
source ../../../utils/functions.sh

echo "Checking if kubectl is already installed..."
if ! command_exists kubectl ; then
    echo "Kubectl is not installed..."
    echo "Attempting to install kubectl (May get asked for the sudo password)"
    sudo apt-get update && sudo apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
fi

kubernetes_api_test=$(curl -ks "$KUBERNETES_API_PROTOCOL://$KUBERNETES_ADDRESS:$KUBERNETES_PORT/api/")

kubernetes_status=$(echo "$kubernetes_api_test" | jq '.versions')

if [ "$kubernetes_status" == "null" ]; then
    echo "Can't connect to Kubernetes with provided information!"
    echo $kubernetes_api_test
    echo "Exiting application!"
    exit 0
else
    echo "Successfully connected to Kubernetes!"
fi

echo "Retrieving Kubernetes nodes..."

kubectl --token="$KUBERNETES_TOKEN" --server="$KUBERNETES_API_PROTOCOL://$KUBERNETES_ADDRESS:$KUBERNETES_PORT" --insecure-skip-tls-verify=true get nodes

if [ $? -ne 0 ]; then
    echo "Error retrieving Kubernetes nodes..."
    echo "Please check the configuration and try again!"
    echo "Exiting installation!"
    exit 0
else
    echo "Kubernetes seems ok!"
fi

echo "Are you sure want to continue deploying kube-openmon on Kubernetes? (y/n)"
read -r con

if [ ! $con == 'y' ] && [ ! $con == 'Y' ]; then
   echo "Exiting installation"
   exit 0
else
   echo "Deploying kube-openmon"
   kubectl --token="$KUBERNETES_TOKEN" --server="$KUBERNETES_API_PROTOCOL://$KUBERNETES_ADDRESS:$KUBERNETES_PORT" --insecure-skip-tls-verify=true apply -f kube-openmon.yaml
fi

