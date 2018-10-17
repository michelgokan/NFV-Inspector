#!/bin/bash

echo "Please enter InfluxDB host: "
read -r influxdb_host

echo "Please enter InfluxDB port: "
read -r influxdb_port

echo "Please enter InfludDB username (if exists): "
read -r influxdb_username

echo "Please enter InfluxDB password (if exists): "
read -r influxdb_password

echo -e "InfluxDB host: $influxdb_host \nInfluxDB port: $influxdb_port \nInfluxDB username: $influxdb_username\nInfluxDB password: $influxdb_password\n"

if ! command_exists influx ; then
    echo 'Error: IndluxDB client is not installed.' >&2

    echo "Attempting to install InfluxDB Client (only works on Ubuntu). May ask for sudo password."
    echo "sudo apt-get install influxdb-client"
    sudo apt-get install influxdb-client
else
    echo "InfluxDB client is installed!"
fi

echo "Attepting to connect to InfluxDB..."
version="$(curl -sl -I http://$influxdb_host:$influxdb_port/ping | awk 'BEGIN{RS="\r\n"} /Influxdb-Version/ {print $2}')"

if [[ $version =~ ^[0-9]+.[0-9]+.[0-9]+.*$ ]];
then
    echo -ne "Successfully connected to InfluxDB (version $version)."
    echo ""
else
    echo "Error connecting to InfluxDB."
    echo $version
    echo "Exiting installation wizard!"
    exit 0
fi

echo "Saving plugin configs"
cat config.json | jq -r ".plugins.InfluxDB = {\"influxdb_host\":\"$influxdb_host\",\"influxdb_port\":\"$influxdb_port\",\"influxdb_username\":\"$influxdb_username\",\"influxdb_password\":\"$influxdb_password\"}" | sponge config.json

