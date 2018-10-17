#!/bin/bash

echo "Please enter ElasticSearch host: "
read -r elasticsearch_host

echo "Please enter Elasticsearch port: "
read -r elasticsearch_port

echo "Please enter Elasticsearch token (if exists): "
read -r elasticsearch_token

echo "Please enter Elasticsearch username (if exists): "
read -r elasticsearch_username

echo "Please enter Elasticsearch password (if exists): "
read -r elasticsearch_password

echo -e "Elasticsearch host: $elasticsearch_host \nElasticsearch port: $elasticsearch_port \nElasticsearch token: $elasticsearch_token\nElasticsearch username: $elasticsearch_username\nElasticsearch password: $elasticsearch_password\n"
echo "Attempting to connect to Elasticsearch..."

#TODO add elasticsearch attempt to connect

echo "Saving plugin configs"
cat config.json | jq -r ".plugins.ElasticSearch = {\"elasticsearch_host\":\"$elasticsearch_host\",\"elasticsearch_port\":\"$elasticsearch_port\",\"elasticsearch_token\":\"$elasticsearch_token\",\"elasticsearch_username\":\"$elasticsearch_username\",\"elasticsearch_password\":\"$elasticsearch_password\"}" | sponge config.json
