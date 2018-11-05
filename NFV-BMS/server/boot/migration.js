'use strict';

module.exports = function (app) {
    var mysqlDs = app.dataSources.mysql;
    var node = app.models.Node;
    var node_type = app.models.NodeType;
    var resource = app.models.Resource;
    var resource_type = app.models.ResourceType;
    var quality_metric = app.models.QualityMetric;
    var vnf = app.models.Vnf;

    mysqlDs.autoupdate("node_type", function (err) {
        console.log("Autoupdated table 'node_type'");

        mysqlDs.autoupdate("node", function (err) {
            console.log("\nAutoupdated table 'node'");
            console.log("\nAutoupdated table 'node'");

            mysqlDs.autoupdate("node_placement_configuration", function (err) {
                console.log("\nAutoupdated table 'node_placement_configuration'");

                mysqlDs.autoupdate("node_properties_configuration", function (err) {
                    console.log("Autoupdated table 'node_properties_configuration'");

                    mysqlDs.autoupdate("node_property", function (err) {
                        console.log("\nAutoupdated table 'node_property'");

                        mysqlDs.autoupdate("node_properties_configuration_property_value", function (err) {
                            console.log("\nAutoupdated table 'node_properties_configuration_property_value'");
                        });
                    });


                    mysqlDs.autoupdate("node_placement_configuration_node_place", function (err) {
                        console.log("\nAutoupdated table 'node_placement_configuration_node_place'");
                    });

                    mysqlDs.autoupdate("deployment", function (err) {
                        console.log("\nAutoupdated table 'deployment'");
                    });
                    mysqlDs.autoupdate("benchmarking_tool_integration_plugin", function (err) {
                        console.log("Autoupdated table 'benchmarking_tool_integration_plugin'");

                        mysqlDs.autoupdate("experiment_set", function (err) {
                            console.log("\nAutoupdated table 'experiment_set'");

                            mysqlDs.autoupdate("experiment", function (err) {
                                console.log("Autoupdated table 'experiment'");

                                mysqlDs.autoupdate("experiment_deployment", function (err) {
                                    console.log("Autoupdated table 'experiment_deployment'");
                                });

                                mysqlDs.autoupdate("resource_type", function (err) {
                                    console.log("Autoupdated table 'resource_type'");

                                    mysqlDs.autoupdate("resource", function (err) {
                                        console.log("\nAutoupdated table 'resource'");

                                        mysqlDs.autoupdate("resource_property", function (err) {
                                            console.log("Autoupdated table 'resource_property'");


                                            mysqlDs.autoupdate("resource_allocation_configuration", function (err) {
                                                console.log("Autoupdated table 'resource_allocation_configuration_id'");

                                                mysqlDs.autoupdate("resource_allocation_configuration_value", function (err) {
                                                    console.log("\nAutoupdated table 'resource_allocation_configuration_value'");
                                                });

                                                mysqlDs.autoupdate("vnf", function (err) {
                                                    console.log("\nAutoupdated table 'vnf'");

                                                    mysqlDs.autoupdate("deployment_vnf", function (err) {
                                                        console.log("\nAutoupdated table 'deployment_vnf'");
                                                    });

                                                    mysqlDs.autoupdate("combined_vnf", function (err) {
                                                        console.log("\nAutoupdated table 'combined_vnf'");
                                                    });


                                                    mysqlDs.autoupdate("quality_metric", function (err) {
                                                        console.log("Autoupdated table 'quality_metric'");

                                                        mysqlDs.autoupdate("experiment_time_interval", function (err) {
                                                            console.log("\nAutoupdated table 'experiment_time_interval'");


                                                            mysqlDs.autoupdate("quality_metric_labeling_configuration", function (err) {
                                                                console.log("Autoupdated table 'quality_metric_labeling_configuration'");

                                                                mysqlDs.autoupdate("quality_metric_labeling_configuration_value", function (err) {
                                                                    console.log("Autoupdated table 'quality_metric_labeling_configuration_value'");
                                                                });

                                                                mysqlDs.autoupdate("experiment_quality_metric_value", function (err) {
                                                                    console.log("\nAutoupdated table 'experiment_quality_metric_value'");
                                                                });

                                                                mysqlDs.autoupdate("experiment_resource_usage_value", function (err) {
                                                                    console.log("\nAutoupdated table 'experiment_resource_usage_value'");
                                                                });


                                                                mysqlDs.autoupdate("experiment_set_sla_goal", function (err) {
                                                                    console.log("Autoupdated table 'experiment_set_sla_goal'");
                                                                });

                                                            });
                                                        });
                                                    });

                                                    mysqlDs.autoupdate("vnf_property", function (err) {
                                                        console.log("Autoupdated table 'vnf_property'");

                                                        mysqlDs.autoupdate("vnf_properties_configuration", function (err) {
                                                            console.log("Autoupdated table 'vnf_properties_configuration'");

                                                            mysqlDs.autoupdate("vnf_properties_configuration_property_value", function (err) {
                                                                console.log("\nAutoupdated table 'vnf_properties_configuration_property_value'");
                                                            });

                                                            mysqlDs.autoupdate("experiment_node_configuration", function (err) {
                                                                console.log("\nAutoupdated table 'experiment_node_configuration'");
                                                            });
                                                        });
                                                    });

                                                    mysqlDs.autoupdate("vnf_resource_requirement", function (err) {
                                                        console.log("\nAutoupdated table 'vnf_resource_requirement'");
                                                    });
                                                });
                                            });
                                        });
                                    });
                                });

                            });
                        });
                        mysqlDs.autoupdate("system_function", function (err) {
                            console.log("Autoupdated table 'system_function'");

                            mysqlDs.autoupdate("traffic_demand_configuration", function (err) {
                                console.log("Autoupdated table 'traffic_demand_configuration'");

                                mysqlDs.autoupdate("experiment_system_function_traffic_demand", function (err) {
                                    console.log("Autoupdated table 'experiment_system_function_traffic_demand'");
                                });
                            });
                        });
                    });
                });
            });

        });
    });
    mysqlDs.autoupdate("endpoint", function (err) {
        console.log("Autoupdated table 'endpoint'");
    });

    mysqlDs.autoupdate("Michel", function (err) {
        console.log("Autoupdated table 'michel'");
    });
};


console.log("Migration started!");
