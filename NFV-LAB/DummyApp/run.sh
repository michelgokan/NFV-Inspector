#!/bin/bash

echo "Welcome to NFV-LAB dummy app"

echo "Defining a benchmarking integration plugin..."
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"nfv-inspector-bms-hss-fe-plugin\" }' 'http://127.0.0.1:3001/api/benchmarking_tool_integration_plugins'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "nfv-inspector-bms-hss-fe-plugin" }' 'http://127.0.0.1:3001/api/benchmarking_tool_integration_plugins'
read -r t

echo "Creating a system function"
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"UPDATE_LOCATION\" }' 'http://127.0.0.1:3001/api/system_functions'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "UPDATE_LOCATION" }' 'http://127.0.0.1:3001/api/system_functions'
read -r t

echo "Creating a traffic demand configuration"
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"sample_traffic_demand_configuration\", \"duration\": 100, \"rate\": 25, \"distribution\": \"uniform\" }' 'http://127.0.0.1:3001/api/traffic_demands_configurations'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "sample_traffic_demand_configuration", "duration": 100, "rate": 25, "distribution": "uniform" }' 'http://127.0.0.1:3001/api/traffic_demands_configurations'
read -r t

echo "Creating Response time quality metric"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{   "quality_metric_type": "vnf_quality_metric",    "name": "response_time", "lower_bound": 0 }' 'http://127.0.0.1:3001/api/quality_metrics'
read -r t

echo "Creating CPU quality metric"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{   "quality_metric_type": "vnf_quality_metric",    "name": "cpu_usage", "lower_bound": 0 }' 'http://127.0.0.1:3001/api/quality_metrics'
read -r t

echo "Creating Memory quality metric"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{   "quality_metric_type": "vnf_quality_metric",    "name": "memory_usage", "lower_bound": 0 }' 'http://127.0.0.1:3001/api/quality_metrics'
read -r t


#echo "Creating CPU resource types"
#curl -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{  "name": "cpu",   "min_cap": 1,   "max_cap": 1024 }' 'http://127.0.0.1:3001/api/resource_types'
#read -r t
#
#echo "Creating Memory resource type"
#curl -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{  "name": "memory",   "min_cap": 1024,   "max_cap": 1024000 }' 'http://127.0.0.1:3001/api/resource_types'
#read -r t
#
#echo "Creating node 1 CPU resource"
#curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "node_1_cpu",  "cap": 8,   "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/resources'
#
#
#echo "Creating node 1 Memory resource"
#curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "node_1_memory",  "cap": 16000,   "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/resources'

echo "Creating an experiment set..."
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{    \"name\": \"test\",    \"generated_by\": \"\",    \"status\": \"\",   \"benchmarking_tool_integration_plugin_id\": \"1\"  }' 'http://127.0.0.1:3001/api/experiment_sets'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{    "name": "test",    "generated_by": "",    "status": "",   "benchmarking_tool_integration_plugin_id": "1"  }' 'http://127.0.0.1:3001/api/experiment_sets'
read -r t

echo "Creating a single experiment and assigning the system function and traffic demand configuration to it"
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{    \"name\": \"MICHEL-UPDATE-LOCATION\",    \"start_time\": \"2018-01-01T00:00:00.000Z\",    \"end_time\": \"2019-01-01T00:00:00.000Z\",    \"status\": \"\",    \"experiment_set_id\": 1  }' 'http://127.0.0.1:3001/api/experiments'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{    "name": "MICHEL-UPDATE-LOCATION",    "start_time": "2018-01-01T00:00:00.000Z",    "end_time": "2019-01-01T00:00:00.000Z",    "status": "",    "experiment_set_id": 1, "traffic_demand_configuration_id": 1, "system_function_id": 1  }' 'http://127.0.0.1:3001/api/experiments'
read -r t

echo "Do you want to start experiment? "
read -r t
echo "curl -X GET --header 'Accept: application/json' 'http://127.0.0.1:3001/api/experiments/1/start'"
curl -X GET --header 'Accept: application/json' 'http://127.0.0.1:3001/api/experiments/1/start'

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:17.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:17.065Z", "end_time": "2018-11-14T05:52:18.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:18.065Z", "end_time": "2018-11-14T05:52:19.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:19.065Z", "end_time": "2018-11-14T05:52:20.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:20.065Z", "end_time": "2018-11-14T05:52:21.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:21.065Z", "end_time": "2018-11-14T05:52:22.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:22.065Z", "end_time": "2018-11-14T05:52:23.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:23.065Z", "end_time": "2018-11-14T05:52:24.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:24.065Z", "end_time": "2018-11-14T05:52:25.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:25.065Z", "end_time": "2018-11-14T05:52:26.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:26.065Z", "end_time": "2018-11-14T05:52:27.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:27.065Z", "end_time": "2018-11-14T05:52:28.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:28.065Z", "end_time": "2018-11-14T05:52:29.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:29.065Z", "end_time": "2018-11-14T05:52:30.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "start_time": "2018-11-14T05:52:16.065Z", "end_time": "2018-11-14T05:52:16.065Z", "throughput": 25, "experiment_id": 1 }' 'http://127.0.0.1:3001/api/experiments_time_intervals'

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 21, "quality_metric_id": 1, "experiment_time_interval_id": 1 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 86, "quality_metric_id": 2, "experiment_time_interval_id": 1 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 2195, "quality_metric_id": 3, "experiment_time_interval_id": 1 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 21, "quality_metric_id": 1, "experiment_time_interval_id": 2 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 86, "quality_metric_id": 2, "experiment_time_interval_id": 2 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 2195, "quality_metric_id": 3, "experiment_time_interval_id": 2 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 42, "quality_metric_id": 1, "experiment_time_interval_id": 3 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 86, "quality_metric_id": 2, "experiment_time_interval_id": 3 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 2195, "quality_metric_id": 3, "experiment_time_interval_id": 3 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 59, "quality_metric_id": 1, "experiment_time_interval_id": 4 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 86, "quality_metric_id": 2, "experiment_time_interval_id": 4 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 2195, "quality_metric_id": 3, "experiment_time_interval_id": 4 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 59, "quality_metric_id": 1, "experiment_time_interval_id": 5 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 86, "quality_metric_id": 2, "experiment_time_interval_id": 5 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 2195, "quality_metric_id": 3, "experiment_time_interval_id": 5 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 59, "quality_metric_id": 1, "experiment_time_interval_id": 6 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 86, "quality_metric_id": 2, "experiment_time_interval_id": 6 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 2195, "quality_metric_id": 3, "experiment_time_interval_id": 6 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 59, "quality_metric_id": 1, "experiment_time_interval_id": 7 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 86, "quality_metric_id": 2, "experiment_time_interval_id": 7 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 2195, "quality_metric_id": 3, "experiment_time_interval_id": 7 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 59, "quality_metric_id": 1, "experiment_time_interval_id": 8 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 86, "quality_metric_id": 2, "experiment_time_interval_id": 8 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 2195, "quality_metric_id": 3, "experiment_time_interval_id": 8 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 59, "quality_metric_id": 1, "experiment_time_interval_id": 9 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 86, "quality_metric_id": 2, "experiment_time_interval_id": 9 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 2195, "quality_metric_id": 3, "experiment_time_interval_id": 9 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 59, "quality_metric_id": 1, "experiment_time_interval_id": 10 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 86, "quality_metric_id": 2, "experiment_time_interval_id": 10 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "value": 2195, "quality_metric_id": 3, "experiment_time_interval_id": 10 }' 'http://127.0.0.1:3001/api/experiments_quality_metrics_values'





