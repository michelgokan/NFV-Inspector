#!/bin/bash

echo "Please enter your required monitoring interval (i.e 1 means 1 second):"
read -r monitoring_interval

echo "Please enter your log level (0,1,2 or 3):"
read -r monitoring_log_level

echo "Monitoring enabled by default? (0=No, 1=Yes):"
read -r monitoring_enabled

echo "Retrieving NFV-MON configuration..."
NFV_MON_CONFIG=$(curl $nfv_mon_server_address:$nfv_mon_server_port)
BACKEND_DB=$(echo $NFV_MON_CONFIG | jq --raw-output '.general.backend_db')

#TODO: HARD-CODED IF: We should change this part!
if [ $BACKEND_DB == 'InfluxDB' ]; then
    echo "InfluxDB is supported!"
    BACKEND_DB_HOST=$(echo $NFV_MON_CONFIG | jq --raw-output '.plugins.InfluxDB.influxdb_host')
    BACKEND_DB_PORT=$(echo $NFV_MON_CONFIG | jq --raw-output '.plugins.InfluxDB.influxdb_port')
    BACKEND_DB_USERNAME=$(echo $NFV_MON_CONFIG | jq --raw-output '.plugins.InfluxDB.influxdb_username')
    BACKEND_DB_PASSWORD=$(echo $NFV_MON_CONFIG | jq --raw-output '.plugins.InfluxDB.influxdb_password')

    echo "Please enter the database name:"
    read -r BACKEND_DB_DATABASE_NAME
else
    echo "No compatible adaptor exists for the $BACKEND_DB database!"
    echo "Consider add a compatible adaptor in adapters folder"
    echo "Exiting installation!"
    exit 0
fi

echo "Retrieved information from NFV-MON server..."
echo -e "Backend database type: $BACKEND_DB \nBackend database address: $BACKEND_DB_HOST \nBackend database port: $BACKEND_DB_PORT \nBackend database username: $BACKEND_DB_USERNAME\nBackend database password: $BACKEND_DB_PASSWORD\n"

NFV_VMS_ADDRESS=$(echo $NFV_MON_CONFIG | jq --raw-output '.general.nfv_vms_address')
NFV_VMS_PORT=$(echo $NFV_MON_CONFIG | jq --raw-output '.general.nfv_vms_port')

echo "Retrieving Kubernetes information from NFV-VMS on $NFV_VMS_ADDRESS:$NFV_VMS_PORT..."
KUBERNETES_ADDRESS=$(curl -X GET --header 'Accept: application/json' "http://$NFV_VMS_ADDRESS:$NFV_VMS_PORT/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22kubernetes_api_address%22%7D%7D" | jq --raw-output '.value')
KUBERNETES_PORT=$(curl -X GET --header 'Accept: application/json' "http://$NFV_VMS_ADDRESS:$NFV_VMS_PORT/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22kubernetes_api_port%22%7D%7D" | jq --raw-output '.value')
KUBERNETES_TOKEN=$(curl -X GET --header 'Accept: application/json' "http://$NFV_VMS_ADDRESS:$NFV_VMS_PORT/api/configurations/findOne?filter=%7B%22where%22%3A%20%7B%22key%22%3A%20%22kubernetes_token%22%7D%7D" | jq --raw-output '.value')

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
if [ $BACKEND_DB == 'InfluxDB' ]; then
    sed -i -e "s/{INFLUXDB_ADDRESS}/$BACKEND_DB_HOST/g" ./kube-openmon.yaml
    sed -i -e "s/{INFLUXDB_PORT}/$BACKEND_DB_PORT/g" ./kube-openmon.yaml
    sed -i -e "s/{INFLUXDB_USERNAME}/$BACKEND_DB_USERNAME/g" ./kube-openmon.yaml
    sed -i -e "s/{INFLUXDB_PASSWORD}/$BACKEND_DB_PASSWORD/g" ./kube-openmon.yaml
    sed -i -e "s/{INFLUXDB_DATABASE}/$BACKEND_DB_DATABASE_NAME/g" ./kube-openmon.yaml
fi

sed -i -e "s/{KUBERNETES_CUSTOM_ADDRESS}/$KUBERNETES_ADDRESS/g" ./kube-openmon.yaml
sed -i -e "s/{KUBERNETES_CUSTOM_PORT}/$KUBERNETES_PORT/g" ./kube-openmon.yaml
sed -i -e "s/{KUBERNETES_CUSTOM_TOKEN}/$KUBERNETES_TOKEN/g" ./kube-openmon.yaml

echo "kube-openmon configuration..."
cat ./kube-openmon.yaml

source ./../../../../utils/functions.sh

echo "Checking if kubectl is already installed..."
if ! $(command_exists kubectl); then
    echo "Kubectl is not installed..."
    echo "Attempting to install kubectl (May get asked for the sudo password)"
    sudo apt-get update && sudo apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
fi

echo "Are you sure want to continue deploying kube-openmon on Kubernetes? (y/n)"
read -r con



if [ ! $con == 'y' ] && [ ! $con == 'Y' ]; then
   echo "Exiting installation"
   exit 0
fi

