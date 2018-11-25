#!/bin/bash


echo "Defining deployment"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "HSS-FE" }' 'http://127.0.0.1:3001/api/deployment'


echo "Defining node types..."
echo "Creating a node type: physical_machine"
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"physical_machine\" }' 'http://127.0.0.1:3001/api/node_types'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "physical_machine" }' 'http://127.0.0.1:3001/api/node_types'

echo "Creating a node type: virtual_machine"
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"virtual_machine\" }' 'http://127.0.0.1:3001/api/node_types'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "virtual_machine" }' 'http://127.0.0.1:3001/api/node_types'

echo "Creating a node type: container"
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"container\" }' 'http://127.0.0.1:3001/api/node_types'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "container" }' 'http://127.0.0.1:3001/api/node_types'

echo "Defining all VNFs (16 VNFs)"

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssstg-gtc-mme0" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssstg-gtc-mme1" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssstg-cms" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssvas-redis" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssvas-openldap" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssstgvas-nats" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-diaserv" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-updateactivets" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-purge" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-authentication" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-cancellocation" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-cms" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-cancellocation" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-ldapserv" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-avg" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-slhinformation" }' 'http://127.0.0.1:3001/api/vnfs'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-updatelocation" }' 'http://127.0.0.1:3001/api/vnfs'

echo "Defining first physical machine: openstack1_compute"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"openstack1_compute\", \"type_id\": 1 }' 'http://127.0.0.1:3001/api/nodes'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "openstack1_compute", "type_id": 1 }' 'http://127.0.0.1:3001/api/nodes'


echo "Defining first physical machine: openstack2_compute"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"openstack2_compute\", \"type_id\": 1 }' 'http://127.0.0.1:3001/api/nodes'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "openstack2_compute", "type_id": 1 }' 'http://127.0.0.1:3001/api/nodes'


echo "Defining first virtual machine: kubernetes1_compute"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"kubernetes1_compute\", \"type_id\": 2 }' 'http://127.0.0.1:3001/api/nodes'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "kubernetes1_compute", "type_id": 2 }' 'http://127.0.0.1:3001/api/nodes'


echo "Defining second virtual machine: kubernetes2_compute"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"kubernetes2_compute\", \"type_id\": 2 }' 'http://127.0.0.1:3001/api/nodes'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "kubernetes2_compute", "type_id": 2 }' 'http://127.0.0.1:3001/api/nodes'



echo "Defining all HSS-FE application containers (22 nodes with type containers)"

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssstg-gtc-mme0-5459cc6656-cq5b8", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssstg-gtc-mme1-5c8685bc7b-9njv9", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssstg-cms-598dd955d9-nkzxk", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssvas-redis-c49fd498c-l5jz8", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssvas-openldap-d96c48d8-8pggt", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hssstgvas-nats-c75f6647d-dnw98", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-diaserv-685785d4f4-fvl9z", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-updateactivets-7b678fcfc9-bscnz", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-purge-6f7ccd9974-qx4t9", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-purge-6f7ccd9974-l99tq", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-authentication-7bd4cd7b85-245gb", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-authentication-7bd4cd7b85-245gb", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-cancellocation-7579c67cb6-b7rxg", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-cms-54dcfbbc47-v2g8x", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-cancellocation-7579c67cb6-9spql", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-ldapserv-7c7cd558c7-d4shz", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-ldapserv-7c7cd558c7-pzjnz", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-avg-cb598d889-77qqn", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-avg-cb598d889-5th6s", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-slhinformation-86f4959546-bg7sg", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-authentication-7bd4cd7b85-vg44t", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-updatelocation-7cd69d8cd7-d98wl", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "hsscna-updatelocation-7cd69d8cd7-dhhfv", "type_id": 3 }' 'http://127.0.0.1:3001/api/nodes'




echo "Now lets place our nodes..."
echo "Creating a node placement configuration: placement1"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"placement1\" }' 'http://127.0.0.1:3001/api/node_placement_configurations'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "placement1" }' 'http://127.0.0.1:3001/api/node_placement_configurations'


echo "Placing physical nodes as root nodes"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"description\": \"Physical nodes as root nodes\", \"node_placement_configuration_id\": 1, \"node_id\": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'"
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"description\": \"Physical nodes as root nodes\", \"node_placement_configuration_id\": 1, \"node_id\": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'"

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "Physical nodes as root nodes", "node_placement_configuration_id": 1, "node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "Physical nodes as root nodes", "node_placement_configuration_id": 1, "node_id": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'



echo "Assigning each virtual machine to a physical node: kubernetes1_compute > openstack1_compute AND kubernetes2_compute > openstack2_compute"

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 3, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 4, "parent_node_id": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'


echo "Assigning each container to a VM"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"description\": \"VMs as child nodes for PNs\", \"node_placement_configuration_id\": 1, \"node_id\": 5, \"parent_node_id\": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 5, "parent_node_id": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 6, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 7, "parent_node_id": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 8, "parent_node_id": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 9, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 10, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 11, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 12, "parent_node_id": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 13, "parent_node_id": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 14, "parent_node_id": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 15, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 16, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 17, "parent_node_id": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 18, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 19, "parent_node_id": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 20, "parent_node_id": 2 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 21, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 22, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 23, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 24, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 25, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "description": "VMs as child nodes for PNs", "node_placement_configuration_id": 1, "node_id": 26, "parent_node_id": 1 }' 'http://127.0.0.1:3001/api/node_placement_configuration_nodes_places'


echo "Lets skip nodes_properties_configuration setup! (it's different from resource allocation)"


echo "Creating a resource type: milicpu"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"milicpu\", \"min_cap\": 500, \"max_cap\": 32000 }' 'http://127.0.0.1:3001/api/resource_types'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "milicpu", "min_cap": 500, "max_cap": 32000 }' 'http://127.0.0.1:3001/api/resource_types'


echo "Creating a resource type: memory"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"memory\", \"min_cap\": 100, \"max_cap\": 32000 }' 'http://127.0.0.1:3001/api/resource_types'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "memory", "min_cap": 500, "max_cap": 32000 }' 'http://127.0.0.1:3001/api/resource_types'



echo "Create VNF resource requirements before creating resource configurations"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"min_cap\": 100, \"max_cap\": 32000, \"vnf_id\": 1, \"resource_type_id\": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'"
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"min_cap\": 500, \"max_cap\": 64000, \"vnf_id\": 1, \"resource_type_id\": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 1, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 1, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 2, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 2, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 3, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 3, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 4, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 4, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 5, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 5, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 6, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 6, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 7, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 7, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 8, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 8, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 9, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 9, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 10, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 10, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 11, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 11, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 12, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 12, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 13, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 13, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 14, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 14, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 15, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 15, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 100, "max_cap": 32000, "vnf_id": 16, "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "min_cap": 500, "max_cap": 64000, "vnf_id": 16, "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/vnfs_resource_requirements'


echo "Lets create resource allocation configurations..."
echo "Creating a resource allocation configuration for physical nodes: physical_nodes_RSA_configuration"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"physical_nodes_RSA_configuration\" }' 'http://127.0.0.1:3001/api/resource_allocation_configurations'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "physical_nodes_RSA_configuration" }' 'http://127.0.0.1:3001/api/resource_allocation_configurations'



echo "Setting up configuration values..."

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"size_value\": 32000, \"limit_value\": 32000, \"resource_allocation_configuration_id\": 1,  \"resource_type_id\": 1 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'"
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"size_value\": 64000, \"limit_value\": 64000, \"resource_allocation_configuration_id\": 1,  \"resource_type_id\": 2 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "size_value": 32000, "limit_value": 32000, "resource_allocation_configuration_id": 1,  "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "size_value": 64000, "limit_value": 64000, "resource_allocation_configuration_id": 1,  "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'



echo "Creating another resource allocation configuration for VMs: vms_RSA_configuration"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"vms_RSA_configuration\" }' 'http://127.0.0.1:3001/api/resource_allocation_configurations'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "vms_RSA_configuration" }' 'http://127.0.0.1:3001/api/resource_allocation_configurations'


echo "Setting up configuration values..."

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"size_value\": 32000, \"limit_value\": 32000, \"resource_allocation_configuration_id\": 2,  \"resource_type_id\": 1 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'"
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"size_value\": 64000, \"limit_value\": 64000, \"resource_allocation_configuration_id\": 2,  \"resource_type_id\": 2 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "size_value": 32000, "limit_value": 32000, "resource_allocation_configuration_id": 2,  "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "size_value": 64000, "limit_value": 64000, "resource_allocation_configuration_id": 2,  "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'



echo "Creating another resource allocation configuration for containers: containers_RSA_configuration"

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"name\": \"containers_RSA_configuration\" }' 'http://127.0.0.1:3001/api/resource_allocation_configurations'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "name": "containers_RSA_configuration" }' 'http://127.0.0.1:3001/api/resource_allocation_configurations'


echo "Setting up configuration values..."

echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"size_value\": 2000, \"limit_value\": 2000, \"resource_allocation_configuration_id\": 3,  \"resource_type_id\": 1 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'"
echo "curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ \"size_value\": 4000, \"limit_value\": 4000, \"resource_allocation_configuration_id\": 3,  \"resource_type_id\": 2 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'"
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "size_value": 2000, "limit_value": 2000, "resource_allocation_configuration_id": 3,  "resource_type_id": 1 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "size_value": 4000, "limit_value": 4000, "resource_allocation_configuration_id": 3,  "resource_type_id": 2 }' 'http://127.0.0.1:3001/api/resource_allocation_configurations_values'



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

