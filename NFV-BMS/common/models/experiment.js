'use strict';
var filter = {
    "include": [
        {
            "relation": "experiment_set",
            "scope": {
                "include": [
                    {
                        "relation": "deployment",
                        "scope": {
                            "include": {
                                "relation": "benchmarking_tool_integration_plugin"
                            }
                        }
                    },
                    {
                        "relation": "experiment_set_nodes_settings",
                        "scope": {
                            "include": [
                                {
                                    "relation": "node",
                                    "scope": {
                                        "include": [
                                            "deployments",
                                            {
                                                "relation": "resource_allocation_configuration",
                                                "scope": {
                                                    "include": ["resource_allocation_configurations_values"]
                                                }
                                            }
                                        ]
                                    }
                                },
                                {
                                    "relation": "resource_allocation_configuration",
                                    "scope": {
                                        "include": ["resource_allocation_configurations_values"]
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "relation": "experiment_set_vnf_components_settings",
                        "scope": {
                            "include": {
                                "relation": "vnf_component",
                                "scope": {
                                    "include": {
                                        "relation": "vnf",
                                        "scope": {
                                            "include": ["deployments"]
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        "relation": "affinity_rule_configuration",
                        "scope": {
                            "include": ["affinity_rule_configuration_values"]
                        }
                    }
                ]
            }
        },
        {
            "relation": "node_placement_configuration",
            "scope":
                {
                    "include":
                        {
                            "relation": "node_placement_configuration_nodes_places",
                            "scope":
                                {
                                    "include":
                                        [
                                            {
                                                "relation": "node",
                                                "scope": {
                                                    "include": [
                                                        "deployments",
                                                        "node_resources_requirements"]
                                                }
                                            },
                                            {
                                                "relation": "parent_node",
                                                "scope": {
                                                    "include": [
                                                        "deployments",
                                                        "node_resources_requirements"]
                                                }
                                            }
                                        ]
                                }
                        }
                }
        },
        {
            "relation": "experiment_nodes_configurations",
            "scope":
                {
                    "include":
                        [
                            {
                                "relation": "resource_allocation_configuration",
                                "scope": {
                                    "include": {
                                        "relation": "resource_allocation_configurations_values"
                                    }
                                }
                            },
                            {
                                "relation": "node",
                                "scope": {
                                    "include": ["deployments"]
                                }
                            }
                        ]
                }
        },
        {
            "relation": "affinity_rule_configuration",
            "scope": {
                "include": ["affinity_rule_configuration_values"]
            }
        }
    ]
};

function generateError(errorMessage, errorStatusCode, errorCode) {
    var error = new Error(errorMessage);
    error.statusCode = error.status = errorStatusCode;
    error.code = errorCode;
    throw error;
}


function isIdInDeploymentsList(deploymentId, deploymentsList) {
    for (let deployment of deploymentsList) {
        if (deployment["id"] === deploymentId) {
            return true;
        }
    }

    return false;
}

function isModelValid(model, name) {
    if (!model)
        generateError("No model with name=" + name + " exists!", 500, 'MODEL_NOT_FOUND');

    return true;
}

function isNodeResourceEditable(node_id, experimentSetNodesSettings) {
    for (let node of experimentSetNodesSettings) {
        if (node["node_id"] === node_id)
            return node["is_resource_editable"];
    }

    generateError(`Node id ${node_id} doesn't have a is_resource_editable value is experiment set ${experimentSetNodesSettings["experiment_set_id"]}`, 500, 'NO_IS_RESOURCE_EDITABLE_DATA');
}

function getNeighbourNodesInPlacement(nodePlacementConfigurationPlaces, node_id) {
    for (let node of nodePlacementConfigurationPlaces) {
        if (node["node_id"] === node_id) {
            if (node["parent_node_id"] !== null)
                return getNodeDirectChildrenInPlacement(nodePlacementConfigurationPlaces, node["parent_node_id"])
            else
                return [];
        }
    }
}

function getNodeDirectChildrenInPlacement(nodePlacementConfigurationPlaces, node_id) {
    var node_ids = [];

    for (let node of nodePlacementConfigurationPlaces) {
        if (node["parent_node_id"] === node_id) {
            node_ids.push(node["node_id"]);
        }
    }

    return node_ids;
}

function getNodeResourceRequestValue(nodeResourceAllocationConfiguration, resource_type_id) {
    var nodeResourceAllocationConfigurationValues = nodeResourceAllocationConfiguration.resource_allocation_configurations_values();

    for (let resAllocValue of nodeResourceAllocationConfigurationValues) {
        if (resAllocValue["resource_type_id"] === resource_type_id) {
            return resAllocValue["size_value"];
        }
    }

    return false;
}

function calculateExperimentNodeAvailableResource(experiment, node_id, resource_type_id) {
    var experimentNodesPlacesConf = experiment.node_placement_configuration();
    var experimentNodesPlaces = experimentNodesPlacesConf.node_placement_configuration_nodes_places();
    var experimentNodeResourceConfiguration = getExperimentNodeResourceConfiguration(experiment, node_id);

    var directNodeChildren = getNodeDirectChildrenInPlacement(experimentNodesPlaces, node_id);
    var remaining_resource = getNodeResourceRequestValue(experimentNodeResourceConfiguration, resource_type_id);

    for (let direct_node_id of directNodeChildren) {
        var nodeRes = getExperimentNodeResourceConfiguration(experiment, direct_node_id);

        remaining_resource -= getNodeResourceRequestValue(nodeRes, resource_type_id);
    }

    return remaining_resource;
}

function getExperimentNodeResourceConfiguration(experiment, node_id) {
    var experimentSet = experiment.experiment_set();
    var experimentSetNodesSettings = experimentSet.experiment_set_nodes_settings();
    var experimentNodesConfigurations = experiment.experiment_nodes_configurations();

    var isNodeResourceConfigsAvailable = false;
    var isNodeResourceConfigsEditable = false;

    if (isNodeResourceEditable(node_id, experimentSetNodesSettings) === true) {
        isNodeResourceConfigsEditable = true;
    }

    for (let experimentNodeConfig of experimentNodesConfigurations) {
        if (experimentNodeConfig["node_id"] === node_id) {
            if (!isNodeResourceConfigsEditable) {
                generateError("No resource configuration for node id " + node_id + " should be defined, as its resources are not editable due to the experiment set id " + experimentSet["id"] + " nodes settings!", 500, 'RESOURCE_IS_NOT_EDITABLE');
            } else {
                return experimentNodeConfig.resource_allocation_configuration();
            }
        }
    }

    for (let experimentSetNode of experimentSetNodesSettings) {
        if (node_id === experimentSetNode["node_id"]) {
            if (experimentSetNode["resource_allocation_configuration_id"] == null) {
                if (experimentSetNode.node()["resource_allocation_configuration_id"] != null) {
                    return experimentSetNode.node().resource_allocation_configuration();
                } else {
                    break;
                }
            } else {
                return experimentSetNode.resource_allocation_configuration();
            }
        }
    }

    if (!isNodeResourceConfigsAvailable) {
        generateError("No resource configuration for node id " + node_id + " exists!", 500, 'NO_RESOURCE_CONFIGURATION');
    }
}

function validateDataIntegrity(experiment) {
    var deploymentCheckOkay = true;

    isModelValid(experiment, "experiment");

    var experimentSet = experiment.experiment_set();
    var benchmarking_tool_integration_plugin;
    var deployment;

    isModelValid(experimentSet, "experiment_set");

    deployment = experimentSet.deployment();

    isModelValid(deployment, "deployment");

    benchmarking_tool_integration_plugin = deployment.benchmarking_tool_integration_plugin();

    isModelValid(benchmarking_tool_integration_plugin, "benchmarking_tool_integration_plugin");

    var experimentNodesPlacesConf = experiment.node_placement_configuration();

    isModelValid(experimentNodesPlacesConf, "node_placement_configuration");

    var experimentNodesPlaces = experimentNodesPlacesConf.node_placement_configuration_nodes_places();

    isModelValid(experimentNodesPlaces, "node_placement_configuration_nodes_places");

    var experimentNodesConfigurations = experiment.experiment_nodes_configurations();

    isModelValid(experimentNodesConfigurations, "experiment_nodes_configurations");

    var experimentSetNodesSettings = experimentSet.experiment_set_nodes_settings();

    isModelValid(experimentSetNodesSettings, "experiment_set_nodes_settings");

    var experimentSetVnfComponentsSettings = experimentSet.experiment_set_vnf_components_settings();

    isModelValid(experimentSetVnfComponentsSettings, "experiment_set_vnf_components_settings");

    var experimentSetDeploymentId = experimentSet["deployment_id"];

    for (let experimentSetNode of experimentSetNodesSettings) {
        var experimentSetNodeDeployments = experimentSetNode.node().deployments();

        if (!isIdInDeploymentsList(experimentSetDeploymentId, experimentSetNodeDeployments)) {
            generateError("Some of the nodes in this experiment\'s experiment set are not in the same deployment as the experiment set\'s deployment", 500, 'DEPLOYMENT_MISMATCH');
        }
    }

    for (let experimentSetVnfComponent of experimentSetVnfComponentsSettings) {
        var experimentSetVnfComponentDeployments = experimentSetVnfComponent.vnf_component().vnf().deployments();

        if (!isIdInDeploymentsList(experimentSetDeploymentId, experimentSetVnfComponentDeployments)) {
            generateError("Some of the vnf components in this experiment\'s experiment set are not in the same deployment as the experiment set\'s deployment", 500, 'DEPLOYMENT_MISMATCH');
        }
    }

    for (let experimentNode of experimentNodesConfigurations) {
        var experimentNodeDeployment = experimentNode.node().deployments();

        if (!isIdInDeploymentsList(experimentSetDeploymentId, experimentNodeDeployment)) {
            generateError("Some of the nodes in this experiment's node configuration are not in the same deployment as the experiment set's deployment", 500, 'DEPLOYMENT_MISMATCH');
        }
    }

    for (let experimentPlacementNode of experimentNodesPlaces) {
        var isRootNode = false;

        var experimentPlacementNodeDeployments = experimentPlacementNode.node().deployments();

        if (experimentPlacementNode["parent_node_id"] == null) {
            isRootNode = true;
        } else {
            var experimentPlacementParentNodeDeployments = experimentPlacementNode.parent_node().deployments();
        }

        if (!isIdInDeploymentsList(experimentSetDeploymentId, experimentPlacementNodeDeployments) ||
            (!isRootNode && !isIdInDeploymentsList(experimentSetDeploymentId, experimentPlacementParentNodeDeployments))) {
            generateError("Some of the nodes or parent nodes in this experiment\'s placement configuration are not in the same deployment as the experiment set\'s deployment", 500, 'DEPLOYMENT_MISMATCH');
        }

        var isNodeResourceConfigsAvailable = false;
        var isNodeResourceConfigsEditable = false;

        if (isNodeResourceEditable(experimentPlacementNode["node_id"], experimentSetNodesSettings) === true) {
            var isNodeResourceConfigsEditable = true;
        }


        for (let experimentNodeConfig of experimentNodesConfigurations) {
            if (experimentPlacementNode["node_id"] === experimentNodeConfig["node_id"]) {
                if (!isNodeResourceConfigsEditable) {
                    generateError("No resource configuration for node id " + experimentPlacementNode["node_id"] + " should be defined, as its resources are not editable due to the experiment set id " + experimentSet["id"] + " nodes settings!", 500, 'RESOURCE_IS_NOT_EDITABLE');
                } else {
                    isNodeResourceConfigsAvailable = true;
                }
            }
        }

        if (!isNodeResourceConfigsAvailable) {
            for (let experimentSetNode of experimentSetNodesSettings) {
                if (experimentPlacementNode["node_id"] === experimentSetNode["node_id"]) {
                    if (experimentSetNode["resource_allocation_configuration_id"] != null ||
                        experimentSetNode.node()["resource_allocation_configuration_id"] != null) {
                        isNodeResourceConfigsAvailable = true;
                        break;
                    }
                }
            }
        }

        if (!isNodeResourceConfigsAvailable) {
            generateError("No resource configuration for node id " + experimentPlacementNode["node_id"] + " exists!", 500, 'NO_RESOURCE_CONFIGURATION');
        }
    }

    return true;
}

function isAffinityRuleSatisfied(affinityRuleConfiguration, nodePlacementConfiguration) {
    var affinityRules = affinityRuleConfiguration.affinity_rule_configuration_values();
    var nodePlaces = nodePlacementConfiguration.node_placement_configuration_nodes_places();

    //var children = getNodeDirectChildrenInPlacement(nodePlaces, node["id"]);

    for (let rule of affinityRules) {
        var node1_parent = null;
        var node2_parent = null;

        for (let node1 of nodePlaces) {
            if (rule["node1_id"] === node1["node_id"]) {
                node1_parent = node1["parent_node_id"];
                break;
            }
        }

        for (let node1 of nodePlaces) {
            if (rule["node2_id"] === node1["node_id"]) {
                node2_parent = node1["parent_node_id"];
                break;
            }
        }

        if (node1_parent !== null && node2_parent !== null) {
            if (!rule["is_antiaffinity"]) { //It's an affinity rule
                if (node1_parent !== node2_parent) {
                    generateError("Error in placement! Affinity rule ID " + rule["id"] + " in affinity configuration ID " + affinityRuleConfiguration["id"] + " is not satisfied for nodes " + rule["node1_id"] + " and " + rule["node2_id"] + "!", 500, 'AFFINITY_ERROR');
                }
            } else { // It's an anti-affinity rule
                if (node1_parent === node2_parent) {
                    generateError("Error in placement! Anti-affinity rule ID " + rule["id"] + " in affinity configuration ID " + affinityRuleConfiguration["id"] + " is not satisfied for nodes " + rule["node1_id"] + " and " + rule["node2_id"] + "!", 500, 'ANTIAFFINITY_ERROR');
                }
            }
        }
    }
}

function getNodesResourceQuotaUsage(experiment, resource_types) {
    var experimentNodesPlacesConf = experiment.node_placement_configuration();
    var experimentNodesPlaces = experimentNodesPlacesConf.node_placement_configuration_nodes_places();

    var jsonString = "[";

    var nodes=[];

    for (let experimentPlacementNode of experimentNodesPlaces) {
        var node = experimentPlacementNode.node();
        var parentNode = experimentPlacementNode.parent_node();

        if (parentNode != null && !nodes.includes(parentNode)) {
            nodes.push(parentNode);
            jsonString += "{\"node_id\": " + parentNode["id"] + ", \"resource_types\": [";
            for (let resourceType of resource_types) {
                var nodeRemainingResourceAmount = calculateExperimentNodeAvailableResource(experiment, parentNode["id"], resourceType["id"]);
                var experimentNodeResourceConf = getExperimentNodeResourceConfiguration(experiment, parentNode["id"]);
                var nodeRequestValue = getNodeResourceRequestValue(experimentNodeResourceConf, resourceType["id"]);
                var quotaUsage = (nodeRequestValue - nodeRemainingResourceAmount) / nodeRequestValue;
                jsonString += "{ \"resource_type_id\": " + resourceType["id"] + ", \"quota_usage\": " + quotaUsage + "},";
            }


            if (resource_types.length > 0)
                jsonString = jsonString.substring(0, jsonString.length - 1);

            jsonString += "]},";
        }
    }
    if (experimentNodesPlaces.length > 0)
        jsonString = jsonString.substring(0, jsonString.length - 1);

    jsonString += "]";

    return JSON.parse(jsonString);
}

function validateNodesPlacementConfiguration(experiment, resource_types) {
    var experimentNodesPlacesConf = experiment.node_placement_configuration();
    var experimentNodesPlaces = experimentNodesPlacesConf.node_placement_configuration_nodes_places();

    var experimentSet = experiment.experiment_set();

    if (experimentSet["affinity_rule_configuration_id"] != null) {
        isAffinityRuleSatisfied(experimentSet.affinity_rule_configuration(), experimentNodesPlacesConf);
    }

    if (experiment["affinity_rule_configuration_id"] != null) {
        isAffinityRuleSatisfied(experiment.affinity_rule_configuration(), experimentNodesPlacesConf);
    }

    for (let experimentPlacementNode of experimentNodesPlaces) {
        var node = experimentPlacementNode.node();
        var parentNode = experimentPlacementNode.parent_node();

        for (let resourceType of resource_types) {
            var node_remaining_resource = calculateExperimentNodeAvailableResource(experiment, parentNode["id"], resourceType["id"]);

            if (node_remaining_resource < 0) {
                generateError("Error in node id " + node["id"] + "! Not enough resource capacity for resource id " + resourceType["id"] + " (remaining capacity=" + node_remaining_resource + ")!", 500, 'PLACEMENT_ERROR');
            }
        }
    }

    return true;
}

module.exports = function (Experiment) {

    Experiment.validate = function (id, cb) {
        process.nextTick(function () {
            Experiment.findById(id, filter, function (err, experiment) {
                if (err !== undefined && err !== "" && err !== null) {
                    cb(err);
                } else {
                    var resourceType = Experiment.app.models.ResourceType;
                    resourceType.find({}, function (err, resource_types) {
                        if (err !== undefined && err !== "" && err !== null) {
                            cb(err);
                        } else {
                            try {
                                var validation1 = validateDataIntegrity(experiment);
                                var validation2 = validateNodesPlacementConfiguration(experiment, resource_types);

                                cb(null, validation1 && validation2);
                            } catch (err) {
                                cb(err);
                            }
                        }
                    });
                }
            });
        });
    };

    Experiment.getNodeResourceAllocationConfiguration = function (id, node_id, cb) {
        process.nextTick(function () {
                Experiment.findById(id, filter, function (err, experiment) {
                        if (err !== undefined && err !== "" && err !== null) {
                            cb(err);
                        } else {
                            try {
                                cb(null, getExperimentNodeResourceConfiguration(experiment, node_id));
                            } catch (err) {
                                cb(err);
                            }
                        }
                    }
                );
            }
        )
    };

    Experiment.placeNode = function (id, node_id, parent_node_id, cb) {
        process.nextTick(function () {
            var placementModel = Experiment.app.models.NodePlacementConfigurationNodePlace;

            Experiment.findById(id, createVirtualPlacement);
            var virtualPlacementId = null;

            function createVirtualPlacement(err, experiment) {
                if (err) cb(err);
                else if (isModelValid(experiment, "experiment")) {
                    placementModel.create({
                        node_placement_configuration_id: experiment["node_placement_configuration_id"],
                        node_id: node_id,
                        parent_node_id: parent_node_id,
                        is_virtual: true
                    }, validateExperiment);
                    console.log("Creating Placement");
                }
            }

            function validateExperiment(err, placement) {
                if (err) cb(err);
                else if (isModelValid(placement, "node_placement_configuration_node_place")) {
                    virtualPlacementId = placement["id"];
                    Experiment.validate(id, handlePlacementValidation);
                    console.log("Validating Experience");
                }
            }

            function handlePlacementValidation(err, result) {
                if (err) {
                    placementModel.destroyById(virtualPlacementId, function (error) {
                        cb(err);
                    });
                } else {
                    console.log("Placement is Okay!");
                    cb(null, result);
                }
            }
        });
    };

    Experiment.getNodesResourceQuotaUsage = function (id, cb) {
        process.nextTick(function () {
            Experiment.findById(id, filter, function (err, experiment) {
                if (err) cb(err);
                else {
                    var resourceType = Experiment.app.models.ResourceType;
                    resourceType.find({}, function (err, resource_types) {
                        if (err !== undefined && err !== "" && err !== null) {
                            cb(err);
                        } else {
                            cb(null, getNodesResourceQuotaUsage(experiment, resource_types));
                        }
                    });
                }
            })
        });
    };

    Experiment.start = function (id, cb) {
        process.nextTick(function () {
            Experiment.findById(id, {
                    include: {
                        relation: 'experiment_set',
                        scope: {
                            include: {
                                relation: "deployment",
                                scope: {
                                    include: {
                                        relation: "benchmarking_tool_integration_plugin"
                                    }
                                }
                            }
                        }
                    }
                }, function (err, experiment) {
                    var message = "";

                    if (err !== undefined && err !== "" && err !== null) {
                        cb(err);
                    } else if (!experiment) {
                        var error = new Error("No model with id " + id + " exists!");
                        error.statusCode = error.status = 404;
                        error.code = 'MODEL_NOT_FOUND';
                        cb(error);
                    } else {
                        var experiment_set = experiment.experiment_set();
                        var benchmarking_tool_integration_plugin;
                        var deployment;
                        message = "Experiment name = " + experiment.name + "\n";

                        if (!experiment_set) {
                            message += "No experiment set has been found!";

                            var error = new Error("No experiment set has been found!");
                            error.statusCode = error.status = 500;
                            cb(error);
                        } else {
                            message += "Experiment set name = " + experiment_set.name;
                            deployment = experiment_set.deployment();

                            if (!deployment) {
                                message += "No deployment for experiment set of this experiment has been found!";

                                var error = new Error("No deployment for experiment set of this experiment has been found!");
                                error.statusCode = error.status = 500;
                                cb(error);
                            } else {
                                message += "Deployment Name = " + deployment.name;
                                benchmarking_tool_integration_plugin = deployment.benchmarking_tool_integration_plugin();
                                message += "\n";

                                if (!benchmarking_tool_integration_plugin) {
                                    message += "No benchmarking tool integration plugin has been found!";
                                } else {
                                    message += "Benchmarking Tool Plugin Name = " + benchmarking_tool_integration_plugin.name;


                                    cb();
                                    //TODO: HARD-CODED PARTS HERE!!!!
                                    // var benchmark_model = Experiment.app.models.NfvInspectorBmsHssFePlugin;
                                    //
                                    // var benchmark_results = new Promise(function (resolve, reject) {
                                    //     benchmark_model.startBenchmark(experiment.name, 25, 100).then(function (response) {
                                    //         console.log(response);
                                    //         message = "OK";
                                    //         resolve(response);
                                    //     });
                                    // });
                                }
                            }
                        }
                        // benchmark_results.then(function (msg) {
                        //     cb(null, msg)
                        // });

                    }
                }
            );
        });
    };
};