'use strict';

module.exports = function (Nodeplacementconfigurationnodeplace) {
    Nodeplacementconfigurationnodeplace.validatesPresenceOf('node_id');
    var app = require('../../server/server');


    Nodeplacementconfigurationnodeplace.observe('before save', function (ctx, next) {
        var nodeModel = app.models.Node;
        var nodePlacementConfigurationModel = app.models.nodePlacementConfiguration;
        var deploymentNodeModel = app.models.deploymentNode;

        var node = nodeModel.find({"where": {"id": ctx.instance["node_id"]}});
        var parentNode = nodeModel.find({"where": {"id": ctx.instance["parent_node_id"]}});
        var nodePlacementConfiguration = nodePlacementConfigurationModel.find({"where": {"id": ctx.instance["node_placement_configuration_id"]}});
        var deploymentOfNode = deploymentNodeModel.find({"where": {"node_id": ctx.instance["node_id"]}});
        var deploymentOfParentNode = deploymentNodeModel.find({"where": {"node_id": ctx.instance["parent_node_id"]}});

        var result = Promise.all([node, parentNode, nodePlacementConfiguration, deploymentOfNode, deploymentOfParentNode]).then(function (values) {
            var nodeValue = values[0];
            var parentNodeValue = values[1];
            var nodePlacementConfigurationValue = values[2];
            var deploymentOfNodeValue = values[3];
            var deploymentOfParentNode = values[4];

            var nodeDeploymentCheckOK = false;
            var parentNodeDeploymentCheckOK = false;

            for (let element of deploymentOfNodeValue) {
                if (element["deployment_id"] === nodePlacementConfigurationValue[0]["deployment_id"]) {
                    nodeDeploymentCheckOK = true;
                    break;
                }
            }

            for (let element of deploymentOfParentNode) {
                if (element["deployment_id"] === nodePlacementConfigurationValue[0]["deployment_id"]) {
                    parentNodeDeploymentCheckOK = true;
                    break;
                }
            }

            if (!nodeDeploymentCheckOK || !parentNodeDeploymentCheckOK) {
                var e = new Error("Node and Parent Nodes are not in the same deployment");
                e.statusCode = 500;
                next(e);
            } else {
                next();
            }
        });
    });
};
