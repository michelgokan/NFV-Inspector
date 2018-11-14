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
                            //TODO: HARD-CODED PARTS HERE!!!!
                            var benchmark_model = Experiment.app.models.NfvInspectorBmsHssFePlugin;

                            var benchmark_results = new Promise(function (resolve, reject) {
                                benchmark_model.startBenchmark(experiment.name, 25, 100).then(function (response) {
                                    console.log(response);
                                    message = "OK";
                                    resolve(response);
                                });
                            });


                            //message += "Benchmarking tool integration plugin name = " + benchmarking_tool_integration_plugin.name;
                            //message += benchmark_results;
                        }

                        benchmark_results.then(function(msg){ cb(null, msg) });

                    }
                }
            )
            ;

//var result = "OK "+id;
//cb(null, result);
        })
        ;
    }
    ;
}
;
