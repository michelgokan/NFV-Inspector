'use strict';

module.exports = function (Experiment) {
    Experiment.start = function (id, cb) {
        process.nextTick(function () {
            Experiment.findById(id, {include: {experimentsExperimentSetIDRelation: 'experimentSetBenchTollIntPlugIdRelation'}}, function (err, experiment) {
                var message = "";

                if (err !== undefined && err !== "" && err !== null) {
                    cb(err);
                } else if (!experiment) {
                    var error = new Error("No model with id " + id + " exists!");
                    error.statusCode = error.status = 404;
                    error.code = 'MODEL_NOT_FOUND';
                    cb(error);
                } else {
                    var experiment_set = experiment.experimentsExperimentSetIDRelation();
                    var benchmarking_tool_integration_plugin;
                    message = "Experiment name = " + experiment.name + "\n";

                    if (!experiment_set) {
                        message += "No experiment set has been found!";
                    } else {
                        message += "Experiment set name = " + experiment_set.name;
                        benchmarking_tool_integration_plugin = experiment_set.experimentSetBenchTollIntPlugIdRelation();
                    }

                    message += "\n";

                    if (!benchmarking_tool_integration_plugin) {
                        message += "No benchmarking tool integration plugin has been found!";
                    } else {
                        message += "Benchmarking tool integration plugin name = " + benchmarking_tool_integration_plugin.name;
                    }

                    cb(null, message);

                }
            });

            //var result = "OK "+id;
            //cb(null, result);
        });
    };
};
