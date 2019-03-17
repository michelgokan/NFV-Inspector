'use strict';

function getNodes(experimentSet) {
    var experimentSetNodesSettings = experimentSet.experiment_set_nodes_settings();

    for (let experimentSetNode of experimentSetNodesSettings) {
        if (experimentSetNode["resource_allocation_configuration_id"] == null) {
            if (experimentSetNode.node()["resource_allocation_configuration_id"] != null) {
                experimentSetNodesSettings["indexed_resource_allocation_configuration_id"] = experimentSetNode.node().resource_allocation_configuration()["id"];
                experimentSetNodesSettings["indexed_resource_allocation_configuration"] = experimentSetNode.node().resource_allocation_configuration();
            }
        }
    }

    return experimentSetNodesSettings;
}

module.exports = function (Experimentset) {
    Experimentset.getNodes = function (id, cb) {
        process.nextTick(function () {
            var filter = {
                "include": [
                    {
                        "relation": "experiment_set_nodes_settings",
                        "scope": {
                            "include": [
                                {
                                    "relation": "node",
                                    "scope": {
                                        "include": [
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
                        "relation": "experiment_set_vnf_components_settings"
                    }
                ]
            };

            Experimentset.findById(id, filter, function (err, experimentset) {
                    if (err !== undefined && err !== "" && err !== null) {
                        cb(err);
                    } else {
                        try {
                            // getNodes function add indexed_resource_allocation_configuration
                            // attribute, so that it'll be easier to get the correct
                            // resource_allocation_configuration_id
                            cb(null, getNodes(experimentset));
                        } catch (err) {
                            cb(err);
                        }
                    }
                }
            );
        });
    };
};
